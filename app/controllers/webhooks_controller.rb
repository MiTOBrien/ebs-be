class WebhooksController < ApplicationController

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
    when 'customer.subscription.updated'
      handle_subscription_updated(event['data']['object'])
    when 'charge.succeeded'
      handle_charge_succeeded(event['data']['object'])
    end
    
    render json: { status: 'success' }
  end

  private

  def handle_checkout_completed(session)
    user_id = session['metadata']['user_id']
    tier = session['metadata']['tier']
    customer_id = session['customer']
    subscription_id = session['subscription']

    return unless user_id

    user = User.find_by(id: user_id)
    return unless user

    user.update!(stripe_customer_id: customer_id)

    if subscription_id
      # Handle recurring subscription
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
    else
      # Handle one-time lifetime purchase
      payment_intent_id = session['payment_intent']
      payment_intent = Stripe::PaymentIntent.retrieve(payment_intent_id)
      amount_cents = payment_intent.amount
      currency = payment_intent.currency

      Subscription.create!(
        user: user,
        stripe_customer_id: customer_id,
        subscription_type: 'lifetime',
        status: 'active',
        current_period_start: Time.current,
        current_period_end: nil,
        amount_cents: amount_cents,
        currency: currency
      )
    end
  end

  def handle_successful_payment(invoice)
    subscription = Subscription.find_by(stripe_subscription_id: invoice['subscription'])
    if subscription
      subscription.update!(status: 'active')
      subscription.user.update!(subscription_status: 'active')
    end
  end

  def handle_charge_succeeded(charge)
    customer_id = charge['customer']
    payment_intent_id = charge['payment_intent']
    amount_cents = charge['amount']
    currency = charge['currency']

    user = User.find_by(stripe_customer_id: customer_id)
    return unless user

    Subscription.create!(
      user: user,
      stripe_customer_id: customer_id,
      subscription_type: 'lifetime',
      status: 'active',
      current_period_start: Time.current,
      current_period_end: nil,
      amount_cents: amount_cents,
      currency: currency
    )
  end

  def handle_failed_payment(invoice)
    subscription = Subscription.find_by(stripe_subscription_id: invoice['subscription'])
    if subscription
      subscription.update!(status: 'past_due')
      subscription.user.update!(subscription_status: 'past_due')
    end
  end

  def handle_subscription_updated(subscription_data)
    Rails.logger.info "Raw subscription_data: #{subscription_data.inspect}"
    incoming_status = subscription_data['status'].to_s
    Rails.logger.info "Updating subscription status to: #{incoming_status}"
    Rails.logger.info "Attempting update with: #{incoming_status.inspect} (#{incoming_status.class})"
    Rails.logger.info "incoming_status == 'active': #{incoming_status == 'active'}"

    subscription = Subscription.find_by(stripe_subscription_id: subscription_data['id'])
    return unless subscription

    valid_statuses = %w[active canceled past_due incomplete canceling]

    if subscription_data['cancel_at_period_end']
      subscription.update!(status: 'canceling')
    elsif valid_statuses.include?(incoming_status)
      subscription.update!(status: incoming_status)
    else
      Rails.logger.warn "Skipping update: invalid status '#{incoming_status}'"
    end
  end
end