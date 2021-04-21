class Api::V1::Users::ImageShowController < ApplicationController
    before_action :check_user 

    def index
        if check_user
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
        else
            render json: {
                error: true, 
                message: "User not found. Login and try again.",
                status: 404
            }, status: 404
        end
    end
end