class Api::V1::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def sign_up_params
    params.permit(:first_name, :last_name, :phone_number, :email, :username, :password)
  end

  def create

    if guest?

      @user = guest_user
      session[:userid] = @user.id
      session[:guest_user_id] = nil
      redirect_to user_path(@user)
    else
      "ENTER"
      super do |resource|
        logger.info ">>>Error: #{resource.errors.full_messages}"
          @user = resource
          code = rand(100..999)
          @user.verification_code = code
          @user.save!

          # Tell the UserMailer to send a welcome email after save
          VerificationMailer.verify_email(@user).deliver_now
      end
    end
      
  end

end