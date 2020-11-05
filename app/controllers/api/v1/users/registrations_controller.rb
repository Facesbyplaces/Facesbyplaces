class Api::V1::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def sign_up_params
    params.permit(:first_name, :last_name, :phone_number, :email, :username, :password)
  end

  def create
      @user = if params[:email].present?
                User.new(sign_up_params)
                super do |resource|
                  logger.info ">>>Error: #{resource.errors.full_messages}"
                    @user = resource
                    code = rand(100..999)
                    @user.verification_code = code
                    @user.save!
          
                    # Tell the UserMailer to send a code to verify email after save
                    VerificationMailer.verify_email(@user).deliver_now
                end
              else
                User.new_guest
                current_user.move_to(user) if current_user && current_user.guest?
                session[:user_id] = user.id   
                render json: {
                  success: true,
                  user:  {
                    user: user
                  },
                  status: 200
                }, status: 200
              end
  end

  def new

  end

end