Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, Rails.application.credentials.dig(:facebook, :facebook_client_id), Rails.application.credentials.dig(:facebook, :facebook_client_secret)
    provider :google_oauth2, Rails.application.credentials.dig(:google, :google_client_id), Rails.application.credentials.dig(:google, :google_client_id)
  end 