class Api::V1::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
  
  def sign_up_params
    params.permit(:facebook_id, :google_id, :account_type, :first_name, :last_name, :phone_number, :email, :username, :password, :device_token)
  end

  def create
    account_type = params[:account_type].to_i
    puts account_type
    
    if account_type  == 1 
      # BLM USER SIGN_UP
      @user = User.new(sign_up_params)
    else
      # ALM USER SIGN_UP
      @user = AlmUser.new(sign_up_params)
    end

    super do |resource|
      logger.info ">>>Error: #{resource.errors.full_messages}"
        @user = resource
        code = rand(100..999)
        @user.verification_code = code
        @user.question = "What's the name of your first dog?"
        @user.hideBirthdate = false 
        @user.hideBirthplace = false 
        @user.hideEmail = false 
        @user.hideAddress = false 
        @user.hidePhonenumber = false 
        @user.is_verified = false
        @user.update({ device_token: params[:device_token] })
        # @user.save!
        

        notifsetting = Notifsetting.new(newMemorial: true, newActivities: true, postLikes: true, postComments: true, addFamily: true, addFriends: true, addAdmin: true)
        notifsetting.account = @user
        notifsetting.save

        # Tell the UserMailer to send a code to verify email after save
        VerificationMailer.verify_email(@user).deliver_now

        # render json: {
        #   status: :success,
        #   user: UserSerializer.new( @user ).attributes
        #   }, status: 200
    end
  end

end