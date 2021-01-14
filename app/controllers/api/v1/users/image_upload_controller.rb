class Api::V1::Users::ImageUploadController < ApplicationController
    before_action :check_user

    def image_upload_params
        params.permit(:id, :image)
    end

    def update  
        if params[:account_type] == "1"
            user = BlmUser.find(params[:user_id])
        else
            user = AlmUser.find(params[:user_id])
        end      
        
        user.update(image: params[:image])

        if user.errors.present?
            render json: {success: false, errors: @image.errors.full_messages, status: 404}, status: 200
        else
            render json: {success: true, message: "Successfully Uploaded Image", status: 200}, status: 200
        end
    end


end