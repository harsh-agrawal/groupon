Rails.configuration.stripe = {
  :publishable_key => CONSTANTS["PUBLISHABLE_KEY"],
  :secret_key      => CONSTANTS["SECRET_KEY"]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]  