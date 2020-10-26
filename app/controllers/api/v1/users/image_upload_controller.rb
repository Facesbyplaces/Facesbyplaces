class Api::V1::Users::ImageUploadController < ApplicationController
    def image_upload_params
        params.permit(:user_id, :image)
    end

    def create
        @user = User.find(params[:user_id])

        # if image_upload_params[:user_id] === @user.id
            @user.update_attribute(:image, image_upload_params[:image])
            render json: {success: true, message: "Successfully Uploaded Image", status: 200}, status: 200      
        if @user.errors.present?
            render json: {success: false, errors: @user.errors.full_messages, status: 404}, status: 200
        end
    end
end