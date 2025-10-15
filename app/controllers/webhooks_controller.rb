class WebhooksController < ApplicationController
  # skip_before_action :verify_authenticity_token
  # skip_forgery_protection
  # protect_from_forgery with: :null_session

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.application.credentials.stripe[:webhook_secret]
      )
    rescue JSON::ParserError => e
      render json: { error: 'Invalid payload' }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      render json: { error: 'Invalid signature' }, status: 400
      return
    end

    case event['type']
    when 'checkout.session.completed'
      handle_checkout_completed(event['data']['object'])
    when 'invoice.payment_succeeded'
      handle_successful_payment(event['data']['object'])
    when 'invoice.payment_failed'
      handle_failed_payment(event['data']['object'])
    end

    render json: { status: 'success' }
  end

  private

  def handle_checkout_completed(session)
    customer_id = session['customer']
    subscription_id = session['subscription']
    user_id = session['metadata']['user_id'] # You must pass this in your Stripe Checkout metadata

    return unless user_id && subscription_id

    user = User.find_by(id: user_id)
    return unless user

    stripe_sub = Stripe::Subscription.retrieve(subscription_id)
    item = stripe_sub.items.data.first

    Subscription.create!(
      user: user,
      stripe_subscription_id: stripe_sub.id,
      stripe_customer_id: customer_id,
      subscription_type: item.price.recurring.interval,
      status: stripe_sub.status,
      current_period_start: Time.at(item.current_period_start),
      current_period_end: Time.at(item.current_period_end),
      amount_cents: item.price.unit_amount,
      currency: item.price.currency
    )
  end

  def handle_successful_payment(invoice)
    subscription = Subscription.find_by(stripe_subscription_id: invoice['subscription'])
    if subscription
      subscription.update!(status: 'active')
      subscription.user.update!(subscription_status: 'active')
    end
  end

  def handle_failed_payment(invoice)
    subscription = Subscription.find_by(stripe_subscription_id: invoice['subscription'])
    if subscription
      subscription.update!(status: 'past_due')
      subscription.user.update!(subscription_status: 'past_due')
    end
  end
end