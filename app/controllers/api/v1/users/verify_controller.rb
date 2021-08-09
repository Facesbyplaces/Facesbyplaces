class Api::V1::Users::VerifyController < ApplicationController
    include Userable
    before_action :authenticate_user
    before_action :set_user
    

    def verify
        return render json: {success: false, message: "Invalid Code", status: 401}, status: 401 unless verify_code_params[:verification_code] === @user.verification_code
        @user.update_attribute(:is_verified, true)
        render json: {success: true, message: "Successfully Verified", status: 200}, status: 200
    end

    private

    def verify_code_params
        params.permit(:verification_code, :user_id, :account_type)
    end
end
