module Overrides
    class Api::V1::Users::OmniauthCallbacksController < ApplicationController
        skip_before_action :verify_authenticity_token, only: :facebook

        # facebook callback
        def facebook
            @user = User.create_from_provider_data(request.env["omniauth.auth"])
            if @user.persisted?
                sign_in_and_redirect @user, event: :authentication
                set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
            else
                flash[:error] = 'There was a problem signing you in through Facebook. Please register or try signing in later.'
                redirect_to new_user_registration_url
            end 
        end
        
        #google callback
        def google_oauth2
            # You need to implement the method below in your model (e.g. app/models/user.rb)
            @user = User.create_from_provider_data(request.env['omniauth.auth'])
    
            if @user.persisted?
            sign_in_and_redirect @user, event: :authentication
            set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
            else
            session['devise.google_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
            redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
            end
        end

        def failure
            flash[:error] = "There was a problem signing you in. Please register or try signing in later."
            redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
        end
    end
end