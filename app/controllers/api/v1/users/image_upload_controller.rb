class Api::V1::Users::ImageUploadController < ApplicationController
    before_action :check_user

    def image_upload_params
        params.permit(:image)
    end

    def create
        if params[:account_type] == "1"
            user = BlmUser.find(params[:user_id])
        else
            user = AlmUser.find(params[:user_id])
        end

        if user != nil
            user.update(image: params[:image])

            if user.errors.present?
                render json: {success: false, errors: user.errors.full_messages, status: 404}, status: 200
            else
                render json: {success: true, message: "Successfully Uploaded Image", status: 200}, status: 200
            end
        else
            render json: {error: "User not found. Sign in or Sign up to continue"}, status: 422
        end
    end

    def update
        
        if params[:account_type] == "1"
            user = BlmUser.find(params[:user_id])
        elsif params[:account_type] == "1"
            user = AlmUser.find(params[:user_id])
        else
            user = user()
        end

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
