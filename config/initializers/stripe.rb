Rails.configuration.stripe = {
  publishable_key: Rails.env.production? ?
    Rails.application.credentials.stripe[:publishable_key_live] :
    Rails.application.credentials.stripe[:publishable_key_test],

  secret_key: Rails.env.production? ?
    Rails.application.credentials.stripe[:secret_key_live] :
    Rails.application.credentials.stripe[:secret_key_test]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

STRIPE_PRICE_IDS = {
  monthly: {
    development: 'price_1SH2o1FE1jMpR7Y1bS4ZaQEe',
    production: 'price_1SLU7uFAHbnOAeZv3IiRVZPG'
  },
  quarterly: {
    development: 'price_1SH2r0FE1jMpR7Y1AZD3Fuqw',
    production: 'price_1SLU7qFAHbnOAeZvKnBDqNcQ'
  annual: {
    development: 'price_1SH2sQFE1jMpR7Y1WBjAHRNl',
    production: 'price_1SLU8HFAHbnOAeZvcMW7DCH7'
  },
  lifetime: {
    development: 'price_1SM6mJFE1jMpR7Y1IMAMLbu3',
    production: 'price_1SPPJYFAHbnOAeZvl1VQp2SS'
  }
}.freeze
