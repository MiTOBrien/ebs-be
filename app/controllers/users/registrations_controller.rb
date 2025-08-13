class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      # Save user roles after successful user creation
      save_user_roles(resource) if params[:user][:roles].present?
      
      # Handle subscription creation after successful user creation
      handle_subscription_creation(resource)
      
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token

      render json: {
        status: { code: 200, message: 'Signed up successfully.',
                  token: @token,
                  data: UserSerializer.new(resource).serializable_hash[:data][:attributes] }
      }
    else
      render json: {
        status: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end

  def sign_up_params
    params.require(:user).permit(:username, :first_name, :last_name, :email, :password, :password_confirmation, 
                                 :charges_for_services, :subscription_type)
  end

  def handle_subscription_creation(user)
    subscription_type = user.subscription_type || 'free'
    
    begin
      if subscription_type == 'free'
        create_free_subscription(user)
      else
        create_paid_subscription(user, subscription_type)
      end
    rescue => e
      Rails.logger.error "Subscription creation failed for user #{user.id}: #{e.message}"
      # You might want to send an email notification or set a flag for manual review
      user.update(subscription_status: 'incomplete')
    end
  end

  def create_free_subscription(user)
    user.subscriptions.create!(
      subscription_type: 'free',
      status: 'active',
      amount_cents: 0,
      currency: 'USD'
    )
    
    user.update!(subscription_status: 'active')
  end

  def create_paid_subscription(user, subscription_type)
    # Set user status to pending until payment is confirmed
    user.update!(subscription_status: 'incomplete')
    
    # Create Stripe customer and subscription
    stripe_customer = create_stripe_customer(user)
    stripe_subscription = create_stripe_subscription(stripe_customer, subscription_type)
    
    # Create local subscription record
    user.subscriptions.create!(
      subscription_type: subscription_type,
      status: 'incomplete', # Will be updated via Stripe webhook
      stripe_subscription_id: stripe_subscription.id,
      stripe_customer_id: stripe_customer.id,
      amount_cents: subscription_amount(subscription_type),
      currency: 'USD',
      current_period_start: Time.at(stripe_subscription.current_period_start),
      current_period_end: Time.at(stripe_subscription.current_period_end)
    )
    
    # You might want to return payment intent client secret to frontend
    # for completing the payment setup
  end

  def create_stripe_customer(user)
    Stripe::Customer.create(
      email: user.email,
      metadata: { user_id: user.id }
    )
  rescue Stripe::StripeError => e
    Rails.logger.error "Stripe customer creation failed: #{e.message}"
    raise "Payment setup failed. Please try again."
  end

  def create_stripe_subscription(customer, subscription_type)
    price_id = stripe_price_id(subscription_type)
    
    Stripe::Subscription.create(
      customer: customer.id,
      items: [{ price: price_id }],
      payment_behavior: 'default_incomplete',
      payment_settings: { save_default_payment_method: 'on_subscription' },
      expand: ['latest_invoice.payment_intent']
    )
  rescue Stripe::StripeError => e
    Rails.logger.error "Stripe subscription creation failed: #{e.message}"
    raise "Subscription setup failed. Please try again."
  end

  def stripe_price_id(subscription_type)
    # You'll need to create these price IDs in your Stripe dashboard
    case subscription_type
    when 'paid_monthly'
      Rails.application.credentials.stripe[:monthly_price_id] || ENV['STRIPE_MONTHLY_PRICE_ID']
    when 'paid_annual'
      Rails.application.credentials.stripe[:annual_price_id] || ENV['STRIPE_ANNUAL_PRICE_ID']
    else
      raise "Invalid subscription type: #{subscription_type}"
    end
  end

  def subscription_amount(subscription_type)
    case subscription_type
    when 'paid_monthly'
      1000 # $10.00
    when 'paid_annual'
      10000 # $100.00
    else
      0
    end
  end

  def save_user_roles(user)
    role_names = params[:user][:roles]
    
    # Map frontend role values to database role names
    role_mapping = {
      'author' => 'Author',
      'arcreader' => 'Arc Reader',
      'betareader' => 'Beta Reader',
      'proofreader' => 'Proof Reader'
    }
    
    role_names.each do |role_name|
      mapped_role_name = role_mapping[role_name.downcase]
      
      if mapped_role_name
        role = Role.find_by(role: mapped_role_name)
        if role
          user.user_roles.create!(role: role)
        else
          Rails.logger.error "Role not found in database: #{mapped_role_name}"
        end
      else
        Rails.logger.warn "Invalid role attempted: #{role_name} for user #{user.id}"
      end
    end
  rescue => e
    Rails.logger.error "Failed to save roles for user #{user.id}: #{e.message}"
    # Role assignment failure shouldn't prevent account creation, but we should log it
    # You might want to set a flag or send an admin notification here
  end
end