class Api::V1::Users::ResendVerificationCodeController < ApplicationController
    include Userable
    before_action :authenticate_user
    before_action :set_user

    def create
        set_user_code(@user)

        # Tell the UserMailer to send a code to verify email after save
        ResendVerificationMailer.resend_verify_email(@user).deliver_now
        render json: { success: true, message:  "An email has been sent to #{@user.email} containing instructions for email verification." }, status: 200

    end

    def set_user_code(user)
        # Set User's Code
        code = rand(100..999)
        user.verification_code = code
        user.save!
    end
end
