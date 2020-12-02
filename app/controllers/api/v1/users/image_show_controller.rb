class Api::V1::Users::ImageShowController < ApplicationController
    before_action :authenticate_user!

    def image_show_params
        params.permit(:user_id)
    end

    def index
        @user = User.find(params[:user_id])
        puts @user.image
        render json: {success: true, user: (request.base_url+url_for(@user.image)), status: 200}, status: 200      
    end
end