Devise.setup do |config|
    #MAILER
    config.mailer_sender = 'facesbyplaces.mailer@gmail.com'

    #OMNIAUTH
    config.omniauth :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], scope: 'public_profile,email'
    config.omniauth :google_oauth2, ENV['GOOGLE_APP_ID'], ENV['GOOGLE_APP_SECRET'], scope: 'userinfo.email,userinfo.profile'
    
  end