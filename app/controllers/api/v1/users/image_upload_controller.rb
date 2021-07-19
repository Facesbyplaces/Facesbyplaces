class Api::V1::Users::ImageUploadController < ApplicationController
    before_action :authenticate_user

    def image_upload_params
        params.permit(:image)
    end

    def create
        update_user_image(user)
    end

    def update
        update_user_image(user)
    end

    def user
        if params[:account_type] == "1"
            return user = User.find(params[:user_id])
        elsif params[:account_type] == "2"
            return user = AlmUser.find(params[:user_id])
        else
            return user = user()
        end
    end

    def update_user_image(user)
        if user != nil
            user.update(image: params[:image])

            if user.errors.present?
                render json: {success: false, errors: user.errors.full_messages, status: 404}, status: 200
            else
                render json: {success: true, message: "Successfully Uploaded Image", user: rails_blob_url(user.image), status: 200}, status: 200
            end
        else
            render json: {error: "pls login"}, status: 422
        end
    end


end
