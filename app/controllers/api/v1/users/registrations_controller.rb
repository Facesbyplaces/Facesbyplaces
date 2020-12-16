class Api::V1::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def sign_up_params
    params.permit(:google_id, :account_type, :first_name, :last_name, :phone_number, :email, :username, :password)
  end

  def create
    @user = User.new(sign_up_params)

    if params[:google_id].present?
      validator = GoogleIDToken::Validator.new
      begin
        validator.check(params[:google_id]) 
        @user.save!
      rescue GoogleIDToken::ValidationError => e
        report "Cannot validate: #{e}"
      end
    else super do |resource|
        logger.info ">>>Error: #{resource.errors.full_messages}"
          @user = resource
          code = rand(100..999)
          @user.verification_code = code
          @user.question = "What's the name of your first dog?"
          @user.save!

          Notifsetting.create(newMemorial: false, newActivities: false, postLikes: false, postComments: false, addFamily: false, addFriends: false, addAdmin: false, user_id: @user.id)

          # Tell the UserMailer to send a code to verify email after save
          VerificationMailer.verify_email(@user).deliver_now
      end
    end
      
  end

end