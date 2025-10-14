class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      # Save user roles after successful user creation
      save_user_roles(resource) if params[:user][:role_ids].present?
      
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
                                 :subscription_type, role_ids: [])
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

  def save_user_roles(user)
    role_ids = params[:user][:role_ids]

    if role_ids.present?
      role_ids.each do |role_id|
        role = Role.find_by(id: role_id)
        if role
          user.user_roles.create!(role: role)
        else
          Rails.logger.error "Role ID not found: #{role_id}"
        end
      end
    else
      Rails.logger.warn "No role_ids provided for user #{user.id}"
    end
  rescue => e
    Rails.logger.error "Failed to save roles for user #{user.id}: #{e.message}" 
  end
end