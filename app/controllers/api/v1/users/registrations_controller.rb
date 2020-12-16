class Api::V1::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def sign_up_params
    params.permit(:facebook_id, :google_id, :account_type, :first_name, :last_name, :phone_number, :email, :username, :password)
  end

  def create
    @user = User.new(sign_up_params)

    if @user.google_id.present?
      validator = GoogleIDToken::Validator.new(expiry: 1800)
      token = @user.google_id
      required_audience = JWT.decode(token, nil, false)[0]['aud'] 
      begin
        payload = validator.check(token, required_audience, required_audience)
        email = payload['email']
        @user.is_verified = true
        @user.hideBirthdate = false 
        @user.hideBirthplace = false 
        @user.hideEmail = false 
        @user.hideAddress = false 
        @user.hidePhonenumber = false 
        @user.save!
      rescue GoogleIDToken::ValidationError => e
        # report "Cannot validate: #{e}"
        return render json: {status: "Cannot validate: #{e}"}, status: 422
      end
    elsif params[:identity_token].present?    # For apple registration
      # Initialized of apple processes
        if !params[:code].present? && !params[:identity_token].present?
          return render json: {status: "error"}, status: 422
        end
        
        @client.authorization_code = params[:code]

        begin
          token_response = @client.access_token!
          rescue AppleID::Client::Error => e
          # puts e # gives useful messages from apple on failure
          return render json: {status: e}, status: 401
        end

        id_token_back_channel = token_response.id_token
        id_token_back_channel.verify!(
          client: @client,
          access_token: token_response.access_token,
        )

        id_token_front_channel = AppleID::IdToken.decode(params[:identity_token])
        id_token_front_channel.verify!(
          client: @client,
          code: params[:code],
        )
        id_token = token_response.id_token
      
      # check if apple id already registered
      @user = User.find_by(apple_uid: id_token.sub)
      if @user.present? 
        return render json: {status: "You already registered"}, status: 409
      end

      # check if apple id already registered
      @user = User.find_by_email(id_token.email)

      if @user.present
        # Enable apple login to existing user
        @user.update_column(:apple_uid, id_token.sub)

        return render json: {status: "You already registered"}, status: 409
      else
        # Register user
        @user = User.register_user_from_apple(id_token.sub, id_token.email)
        @user.update(first_name: params[:first_name], last_name: params[:last_name], phone_number: params[:phone_number], account_type: params[:account_type], hideBirthdate: false, hideBirthplace: false, hideEmail: false, hideAddress: false, hidePhonenumber: false)
        
        return render json: {
          status: :created,
          user: UserSerializer.new( @user ).attributes
          }, status: 200
      end
    else super do |resource|
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
          @user.save!

          Notifsetting.create(newMemorial: false, newActivities: false, postLikes: false, postComments: false, addFamily: false, addFriends: false, addAdmin: false, user_id: @user.id)

          # Tell the UserMailer to send a code to verify email after save
          VerificationMailer.verify_email(@user).deliver_now
      end
    end  
  end

end