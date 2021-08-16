class Api::V1::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def create
    @user = user
    
    super do |resource|
      logger.info ">>>Error: #{resource.errors.full_messages}"
        @user = resource
        set_user_details(@user)
        # @user.save!

        # Tell the UserMailer to send a code to verify email after save
        VerificationMailer.verify_email(@user).deliver_now
    end
  end

  private

  def sign_up_params
    params.permit(:facebook_id, :google_id, :account_type, :first_name, :last_name, :phone_number, :email, :username, :password, :device_token)
  end

  def user 
    if params[:account_type]  == "1" 
      # BLM USER SIGN_UP
      return user = User.new(sign_up_params)
    else
      # ALM USER SIGN_UP
      return user = AlmUser.new(sign_up_params)
    end
  end

  def set_user_details(user)
    code = rand(100..999)
    user.verification_code = code
    user.question = "What's the name of your first dog?"
    user.hideBirthdate = false 
    user.hideBirthplace = false 
    user.hideEmail = false 
    user.hideAddress = false 
    user.hidePhonenumber = false 
    user.is_verified = false
    user.update({ device_token: params[:device_token] })

    notifsetting = Notifsetting.new(newMemorial: true, newActivities: true, postLikes: true, postComments: true, addFamily: true, addFriends: true, addAdmin: true)
    notifsetting.account = user
    
    begin 
      notifsetting.save
    rescue ActiveRecord::StatementInvalid => e
      if e.message =~ /^PG::NotNullViolation/
        notifsetting.ignore_type = false
        notifsetting.ignore_id = notifsetting.id == nil ? 1 : Notifsetting.last.id + 1
        notifsetting.user_id = notifsetting.account_id
        notifsetting.save
      end
    end
  end

end