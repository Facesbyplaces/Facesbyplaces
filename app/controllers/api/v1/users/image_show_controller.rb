class Api::V1::Users::ImageShowController < ApplicationController
    before_action :authenticate_user

    def index
        ActiveStorage::Current.host = "https://facesbyplaces.com/"
        render json: {
            success: true, 
            user: {
                id: user().id,
                account_type: user().account_type,
                first_name: user().first_name.to_s,
                last_name: user().last_name.to_s,
                image: user().image.attached? ? (user.image.service_url) : "",
                email: user().email,
                guest: user().guest,
            }, 
            status: 200
        }, status: 200 
    end
end