class Api::V1::Users::ResendVerificationCodeController < ApplicationController
    before_action :check_user

    def create
        @user = user
        set_user_code(@user)

        # Tell the UserMailer to send a code to verify email after save
        ResendVerificationMailer.resend_verify_email(@user).deliver_now
        render json: { success: true, message:  "An email has been sent to #{@user.email} containing instructions for email verification." }, status: 200

    end

    def user
        # Find User
        if params[:account_type] == "1"
            return user = User.find(params[:user_id])
        else
            return user = AlmUser.find(params[:user_id])
        end
    end

    def set_user_code(user)
        # Set User's Code
        code = rand(100..999)
        user.verification_code = code
        user.save!
    end
end
