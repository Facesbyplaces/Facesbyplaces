source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.1'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 3.1'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'sqlite3', '~> 1.4'

  # Use Dotenv for environment variables
  gem 'dotenv', '~> 2.2.1'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Newly added
gem 'devise'
gem 'omniauth'
gem 'devise_token_auth'
gem 'rack-cors'
gem 'active_model_serializers'
gem 'pagy'
gem 'pager_api'
gem 'cancancan'
gem 'rolify'
gem 'stripe'
gem 'kaminari'
gem 'geocoder'
gem 'pg_search', '~> 2.3', '>= 2.3.2'
gem 'google-id-token', git: 'https://github.com/google/google-id-token.git'
gem 'apple_id'

# Social Share 
gem 'social-share-button'

# Use Omniauth Facebook plugin
gem 'omniauth-facebook'
# Use Omniatuh Apple plugin
gem 'omniauth-apple'
# Use Omniauth Google plugin
gem 'omniauth-google-oauth2'
# Use ActiveRecord Sessions
gem 'activerecord-session_store'

# DATABASE
  # For production
  gem 'pg', '~> 1.2', '>= 1.2.3'