class PaymentsController < ApplicationController
  before_action :authenticate_user!

  PRICE_IDS = {
    'monthly' => 'monthly_subscription',
    'quarterly' => 'quarterly_subscription',
    'annual' => 'annual_subscription'
  }

  def create_checkout_session
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
      success_url: 'http://localhost:3000/success',
      cancel_url: 'http://localhost:3000/cancel'
    )

    render json: { id: session.id }
  end
end
