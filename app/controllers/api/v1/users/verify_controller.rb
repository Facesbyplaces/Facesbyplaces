class Api::V1::Users::VerifyController < ApplicationController
    set_account_type = 1 ? (before_action :authenticate_user!) : (before_action :authenticate_alm_user!) 

    def verify_code_params
        params.permit(:verification_code, :user_id, :account_type)
    end

    def create
        @user = user
        
        if verify_code_params[:verification_code] === @user.verification_code
            @user.update_attribute(:is_verified, true)
            render json: {success: true, message: "Successfully Verified", status: 200}, status: 200
        elsif verify_code_params[:verification_code] != @user.verification_code  
            render json: {success: false, message: "Invalid Code", status: 401}, status: 401
        elsif @user.errors.present?
            render json: {success: false, errors: @user.errors.full_messages, status: 404}, status: 404
        end
    end

    def user
        if params[:account_type] == "1"
            return user = User.find(params[:user_id])
        else
            return user = AlmUser.find(params[:user_id])
        end
    end

end
