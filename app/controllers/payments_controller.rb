class PaymentsController < ApplicationController
  before_action :authenticate_user!

  PRICE_IDS = {
    'monthly' => 'price_1SH2o1FE1jMpR7Y1bS4ZaQEe',
    'quarterly' => 'price_1SH2r0FE1jMpR7Y1AZD3Fuqw',
    'annual' => 'price_1SH2sQFE1jMpR7Y1WBjAHRNl'
  }

  def create_checkout_session
    base_url = Rails.env.production? ?
    Rails.application.credentials.dig(:stripe, :base_url_live) :
    Rails.application.credentials.dig(:stripe, :base_url_test)

    tier = params[:tier]
    price_id = PRICE_IDS[tier]

    unless price_id
      render json: { error: 'Invalid tier selected' }, status: :unprocessable_entity and return
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price: price_id,
        quantity: 1
      }],
      mode: 'subscription',
      customer_email: current_user.email,
      success_url: "#{base_url}/success",
      cancel_url: "#{base_url}/cancel"
    )

    render json: { url: session.url }
  end
end
