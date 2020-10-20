class Api::V1::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def sign_up_params
    params.permit(:first_name, :last_name, :phone_number, :email, :username, :password)
  end

  def create
    "ENTER"
    super do |resource|
       logger.info ">>>Error: #{resource.errors.full_messages}"
        @user = resource
        code = [rand(0..9), rand(0..9), rand(0..9)]
        @user.verification_code = code
        @user.save!
    end
  end

end