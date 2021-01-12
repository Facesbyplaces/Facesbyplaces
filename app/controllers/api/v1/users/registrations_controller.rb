class Api::V1::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def sign_up_params
    params.permit(:facebook_id, :google_id, :account_type, :first_name, :last_name, :phone_number, :email, :username, :password)
  end

  def create
    account_type = params[:account_type].to_i
    
    if account_type  == 2 
      @user = AlmUser.new(sign_up_params)
    else
      @user = BlmUser.new(sign_up_params)
    end

    # super do |resource|
    #   logger.info ">>>Error: #{resource.errors.full_messages}"
    #     @user = resource
        code = rand(100..999)
        @user.verification_code = code
        @user.question = "What's the name of your first dog?"
        @user.hideBirthdate = false 
        @user.hideBirthplace = false 
        @user.hideEmail = false 
        @user.hideAddress = false 
        @user.hidePhonenumber = false 
        @user.is_verified = false
        @user.save!

        Notifsetting.create(newMemorial: true, newActivities: true, postLikes: true, postComments: true, addFamily: true, addFriends: true, addAdmin: true, account: @user)

        # Tell the UserMailer to send a code to verify email after save
        VerificationMailer.verify_email(@user).deliver_now
        render json: {
          status: :success,
          user: UserSerializer.new( @user ).attributes
          }, status: 200
    # end
  end

end