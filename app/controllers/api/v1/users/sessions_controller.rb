class Api::V1::Users::SessionsController < DeviseTokenAuth::SessionsController
  before_action :setup_apple_client, only: [:apple]

    def render_create_success
      user = @resource
      if user.is_verified?
        render json: { success: true, user:  user, status: 200 }, status: 200
      end
    end

    def create
      #Facebook Login
      if params[:facebook_id].present?
        @user = User.where(facebook_id: params[:facebook_id]).first

        if @user
          # super
          # return render json: {status: "fb"}, status: 200
          return sign_in(@user, store: true, bypass: false)
        else
          @user = User.new(sign_up_params_google_and_fb)

          @user.facebook_id = @user.facebook_id
          @user.hideBirthdate = false 
          @user.hideBirthplace = false 
          @user.hideEmail = false 
          @user.hideAddress = false 
          @user.hidePhonenumber = false 
          @user.save!

          @user.update(is_verified: true)

          render json: {status: "success", user: @user }
        end
      #Google Login
      elsif params[:google_id].present?
        @user = User.where(google_id: params[:google_id]).first

        if @user
          super
        else
          @user = User.new(sign_up_params_google_and_fb)
          validator = GoogleIDToken::Validator.new
          token = @user.google_id
          required_audience = JWT.decode(token, nil, false)[0]['aud'] 
          begin
            payload = validator.check(token, required_audience, required_audience)
            email = payload['email']

            @user.hideBirthdate = false 
            @user.hideBirthplace = false 
            @user.hideEmail = false 
            @user.hideAddress = false 
            @user.hidePhonenumber = false 
            @user.is_verified = true
            @user.save!

            @user.update(is_verified: true)
    
            render json: UserSerializer.new( @user ).attributes
          rescue GoogleIDToken::ValidationError => e
            return render json: {status: "Cannot validate: #{e}"}, status: 422
          end
        end
      # Apple Login
      elsif params[:code].present? && params[:identity_token].present?
        # Initialized of apple processes
          setup_apple_client()
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

        @user = User.find_by(apple_uid: id_token.sub)
        if @user.present?
          super
        end
  
        @user = User.find_by_email(id_token.email)
  
        if @user.present?
          super
        else
          # Register user
          @user = User.new(sign_up_params_apple)

          @user.is_verified = true
          @user.hideBirthdate = false 
          @user.hideBirthplace = false 
          @user.hideEmail = false 
          @user.hideAddress = false 
          @user.hidePhonenumber = false 
          @user.apple_uid = id_token.email
          @user.email = id_token.sub
          @user.provider = :apple # devise_token_auth attribute, but you can add it yourself.
          @user.uid = id_token.sub # devise_token_auth attribute

          @user.save!
          
          return render json: {
            status: :created,
            user: UserSerializer.new( @user ).attributes
            }, status: 200
        end
      # Fbp Login
      else
        user = User.find_by(email: params[:email])
        account_type = params[:account_type].to_i
    
        if user.account_type == account_type && user.is_verified?
          super
        elsif user.account_type != account_type
          if account_type == 1
            render json: { message: "BLM account not found. Register to login to the page.", status: 401 }
          elsif account_type == 2
            render json: { message: "ALM account not found. Register to login to the page.", status: 401 }
          end
        else
          render json: {
              message: "Verify email to login to the app.",
          }, status: 200
        end
      end
      
    end

    def sign_up_params
      params.permit(:facebook_id, :google_id, :account_type, :first_name, :last_name, :phone_number, :email, :username, :password)
    end
    
    def sign_up_params_google_and_fb
      params.permit(:facebook_id, :google_id, :account_type, :first_name, :last_name, :phone_number, :email, :username)
    end
    
    def sign_up_params_apple
      params.permit(:facebook_id, :google_id, :account_type, :first_name, :last_name, :phone_number, :username)
    end

    protected

    def valid_params?(key, val)
      params[:facebook_id].present? || params[:google_id].present? ? "" : resource_params[:password] && key && val
    end

    private

    def setup_apple_client
      @client ||= AppleID::Client.new(
      identifier: Rails.application.credentials.dig(:apple, :apple_client_id),
      team_id: Rails.application.credentials.dig(:apple, :apple_team_id),
      key_id: Rails.application.credentials.dig(:apple, :apple_key_id),
      private_key: OpenSSL::PKey::EC.new(Rails.application.credentials.dig(:apple, :apple_private_key)),
      redirect_uri: ENV['APPLE_REDIRECT_URI']
      )
    end

    

end

# def facebook
    #   if params[:facebook_id].nil?
    #     return render ResponseBuilder.bad_request "A facebook id is needed"
    #   end
      
    #   @user = User.where(facebook_id: params[:facebook_id]).first

    #   if @user
    #     render :create, status: :ok
    #   else
    #     render ResponseBuilder.bad_request "This facebook is not linked to any account."
    #   end
    # end

    # def google
    #   if params[:google_id].nil?
    #     return render ResponseBuilder.bad_request "A Google id is needed"
    #   end
      
    #   @user = User.where(google_id: params[:google_id]).first

    #   if @user
    #     sign_in(:user, @resource, store: false, bypass: false)
    #     render_create_success
    #   else
    #     render ResponseBuilder.bad_request "This facebook is not linked to any account."
    #   end
    # end 