class Api::V1::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def sign_up_params
    params.permit(:facebook_id, :google_id, :account_type, :first_name, :last_name, :phone_number, :email, :username, :password)
  end

  def create
    @user = User.new(sign_up_params)

    super do |resource|
        logger.info ">>>Error: #{resource.errors.full_messages}"
          @user = resource
          if @user.google_id?
            @user.is_verified = true
            @user.save!
          else
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