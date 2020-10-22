class Api::V1::Users::VerifyController < ApplicationController
    def verify_code_params
        params.permit(:verification_code, :user_id)
    end

    def create
        @user = User.find(params[:user_id])
        if verify_code_params[:verification_code] === @user.verification_code
            @user.update_attribute(:is_verified, true)
            render json: {success: true, message: "Successfully Verified", status: 200}, status: 200      
        elsif @user.errors.present?
            render json: {success: false, errors: @user.errors.full_messages, status: 404}, status: 200
        end
    end

end
