class Api::V1::Users::SessionsController < DeviseTokenAuth::SessionsController
  before_action :setup_apple_client, only: [:apple]

    def render_create_success
      user = @resource
      if user.is_verified?
        render json: {
          success: true,
          user:  {
            account_type: user.account_type,
            id: user.id,
            email: user.email,
            username: user.username.to_s,
            first_name: user.first_name.to_s,
            last_name: user.last_name.to_s,
            is_verified: user.is_verified,
            # image: user.image.attached? ? (request.base_url+url_for(user.image)) : "",
            phone_number: user.phone_number.to_s
          },
          status: 200
        }, status: 200
      end
    end

    def create
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

    def facebook
      if params[:facebook_id].nil?
        return render ResponseBuilder.bad_request "A facebook id is needed"
      end
      
      @user = User.where(facebook_id: params[:facebook_id]).first

      if @user
        render :create, status: :ok
      else
        render ResponseBuilder.bad_request "This facebook is not linked to any account."
      end
    end

    def google
      if params[:google_id].nil?
        return render ResponseBuilder.bad_request "A Google id is needed"
      end
      
      @user = User.where(google_id: params[:google_id]).first

      if @user
        render :create, status: :ok
      else
        render ResponseBuilder.bad_request "This facebook is not linked to any account."
      end
    end

    def apple
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
          client: @client
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
        sign_in(@user, store: true, bypass: false) # Devise method
        return render status: 200, json: {
          status: "success",
          user: UserSerializer.new( @user ).attributes
        }
      end

      @user = User.find_by_email(id_token.email)

      if @user.present?
        # Enable apple login to existing user
        @user.update_column(:apple_uid, id_token.sub)
        sign_in(@user, store: true, bypass: false) # Devise method
        return render status: 200, json: {
          status: "success",
          user: UserSerializer.new( @user ).attributes
        }
      else
        return json: {status: "Account not found"}, status: 404
      end
    end

    private
    def setup_apple_client
      @client ||= AppleID::Client.new(
      identifier: ENV['APPLE_CLIENT_ID'],
      team_id: ENV['APPLE_TEAM_ID'],
      key_id: ENV['APPLE_KEY'],
      private_key: OpenSSL::PKey::EC.new(ENV['APPLE_PRIVATE_KEY']),
      redirect_uri: ENV['APPLE_REDIRECT_URI']
      )
    end
end