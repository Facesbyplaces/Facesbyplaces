class Api::V1::Users::ImageShowController < ApplicationController
    before_action :authenticate_user!

    def image_show_params
        params.permit(:id)
    end

    def index
        render json: {
            success: true, 
            user: {
                first_name: user.first_name.to_s,
                last_name: user.last_name.to_s,
                image: user.image.present? ? (request.base_url+url_for(user.image)) : "",
            }, 
            status: 200
        }, status: 200      
    end
end