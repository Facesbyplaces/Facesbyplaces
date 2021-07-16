class Api::V1::Users::ImageShowController < ApplicationController
    set_account_type = 1 ? (before_action :authenticate_user!) : (before_action :authenticate_alm_user!)  

    def index
        render json: {
            success: true, 
            user: {
                id: user().id,
                account_type: user().account_type,
                first_name: user().first_name.to_s,
                last_name: user().last_name.to_s,
                image: user().image.attached? ? (url_for(user.image)) : "",
                email: user().email,
                guest: user().guest,
            }, 
            status: 200
        }, status: 200 
    end
end