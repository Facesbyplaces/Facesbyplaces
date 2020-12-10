class Api::V1::Users::ImageShowController < ApplicationController
    before_action :authenticate_user!

    def index
        render json: {
            success: true, 
            user: {
                id: user.id,
                first_name: user.first_name.to_s,
                last_name: user.last_name.to_s,
                image: user.image.attached? ? (url_for(user.image)) : "",
                email: user.email,
            }, 
            status: 200
        }, status: 200      
    end
end