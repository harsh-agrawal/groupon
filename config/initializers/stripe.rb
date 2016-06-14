Rails.configuration.stripe = {
  :publishable_key => PUBLISHABLE_KEY,
  :secret_key      => SECRET_KEY
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]  