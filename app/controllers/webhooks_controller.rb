class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

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
    when 'invoice.payment_succeeded'
      handle_successful_payment(event['data']['object'])
    when 'invoice.payment_failed'
      handle_failed_payment(event['data']['object'])
    end

    render json: { status: 'success' }
  end

  private

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