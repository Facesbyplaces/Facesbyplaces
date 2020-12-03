class Api::V1::Users::ImageUploadController < ApplicationController

    def image_upload_params
        params.permit(:id, :image)
    end

    def update
        @user = User.find(params[:id])

        if image_upload_params[:id].to_i === @user.id && @user.id === user.id
            @user.update(image: image_upload_params[:image])
            render json: {success: true, message: "Successfully Uploaded Image", status: 200}, status: 200
        elsif  @user.id != user.id
            render json: {success: false, message: "User with that ID not found", status: 404}, status: 404
        elsif @user.errors.present?
            render json: {success: false, errors: @user.errors.full_messages, status: 404}, status: 200
        end
    end


end