class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create_checkout_session
    base_url = Rails.env.production? ?
      Rails.application.credentials.dig(:stripe, :base_url_live) :
      Rails.application.credentials.dig(:stripe, :base_url_test)

    tier = params[:tier]
    mode = tier == 'lifetime' ? 'payment' : 'subscription'
    price_id = STRIPE_PRICE_IDS[tier.to_sym][Rails.env.to_sym]

    unless price_id
      render json: { error: 'Invalid tier selected' }, status: :unprocessable_entity and return
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price: price_id,
        quantity: 1
      }],
      mode: mode,
      customer_email: current_user.email,
      success_url: "#{base_url}/success",
      cancel_url: "#{base_url}/cancel",
      allow_promotion_codes: true,
      metadata: {
        user_id: current_user.id,
        tier: tier
      }
    )

    render json: { url: session.url }
  end

  def cancel
    subscription_id = params[:id]
    Stripe::Subscription.update(subscription_id, { cancel_at_period_end: true })
    render json: { success: true }
  end
end
