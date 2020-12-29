# frozen_string_literal: true

AppleAuth.configure do |config|
  config.apple_client_id = Rails.application.credentials.dig(:apple, :apple_client_id)
  config.apple_private_key = Rails.application.credentials.dig(:apple, :apple_private_key)
  config.apple_key_id = Rails.application.credentials.dig(:apple, :apple_key_id)
  config.apple_team_id = Rails.application.credentials.dig(:apple, :apple_team_id)
  config.redirect_uri = ENV['APPLE_REDIRECT_URI']
end
