Rails.configuration.stripe = {
    :publishable_key => Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :publishable_key),
    :secret_key      => Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :secret_key)
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]