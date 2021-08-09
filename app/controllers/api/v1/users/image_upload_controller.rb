class Api::V1::Users::ImageUploadController < ApplicationController
    include Userable
    before_action :authenticate_user
    before_action :set_user

    def create
        update_user_image
    end

    def update
        update_user_image
    end

    private

    def image_upload_params
        params.permit(:image)
    end

    def update_user_image
        return render json: {error: "No Current User"}, status: 422 unless @user != nil
        return render json: {success: false, errors: @user.errors.full_messages, status: 404}, status: 200 unless @user.update(image: params[:image])
        render json: {success: true, message: "Successfully Uploaded Image", user: rails_blob_url(@user.image), status: 200}, status: 200
    end


end
