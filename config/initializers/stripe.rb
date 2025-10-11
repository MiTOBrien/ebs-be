Rails.configuration.stripe = {
  publishable_key: Rails.env.production? ?
    Rails.application.credentials.stripe[:publishable_key_live] :
    Rails.application.credentials.stripe[:publishable_key_test],

  secret_key: Rails.env.production? ?
    Rails.application.credentials.stripe[:secret_key_live] :
    Rails.application.credentials.stripe[:secret_key_test]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]