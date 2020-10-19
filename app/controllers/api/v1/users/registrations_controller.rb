class Api::V1::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def sign_up_params
    params.permit(:first_name, :last_name, :phone_number, :email, :username, :password)
  end

  def create
    "ENTER"
    super do |resource|
       logger.info ">>>Error: #{resource.errors.full_messages}"
    end
  end

end