class Api::V1::Users::SessionsController < DeviseTokenAuth::SessionsController

    def render_create_success
      user = @resource
      if user.is_verified?
        render json: { success: true, user:  user, status: 200 }, status: 200
      end
    end

    def create
      #Facebook Login
      if params[:facebook_id].present?
        @user = User.where(email: params[:email], account_type: params[:account_type]).first

        if @user
          params[:password] = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
          @user.password = @user.password_confirmation = params[:password]
          @user.save
          super
        else
          @user = User.new(sign_up_params)

          @user.facebook_id = @user.facebook_id
          @user.hideBirthdate = false 
          @user.hideBirthplace = false 
          @user.hideEmail = false 
          @user.hideAddress = false 
          @user.hidePhonenumber = false 
          @user.is_verified = true

          # image
          if params[:image].present? 
            downloaded_image = URI.open(params[:image])
            filename = File.basename(URI.parse(params[:image]).path)
            @user.image.attach(io: downloaded_image  , filename: filename)
          end

          @user.save!
          params[:password] = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
          @user.password = @user.password_confirmation = params[:password]
          @user.save
          super
        end
      #Google Login
      elsif params[:google_id].present?
        validator = GoogleIDToken::Validator.new
        required_audience = JWT.decode(params[:google_id], nil, false)[0]['aud'] 
        begin
          payload = validator.check(params[:google_id], required_audience, required_audience)
          @user = User.where(email: payload['email'], account_type: params[:account_type]).first
        rescue GoogleIDToken::ValidationError => e
          @user = nil
          return render json: {status: "Cannot validate: #{e}"}, status: 422
        end

        if @user
          params[:email] = @user.email
          params[:password] = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
          @user.password = @user.password_confirmation = params[:password]
          @user.save
          super
        else
          @user = User.new(sign_up_params)
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

            # image
            if params[:image].present? 
              downloaded_image = URI.open(params[:image])
              filename = File.basename(URI.parse(params[:image]).path)
              @user.image.attach(io: downloaded_image  , filename: filename)
            end

            @user.save!
            params[:password] = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
            @user.password = @user.password_confirmation = params[:password]
            @user.save
            super
          rescue GoogleIDToken::ValidationError => e
            return render json: {status: "Cannot validate: #{e}"}, status: 422
          end
        end
      # Apple Login
      elsif params[:user_identification].present? && params[:identity_token].present?
        apple = AppleAuth::UserIdentity.new(params[:user_identification], params[:identity_token]).validate!
        
        @user = User.where(email: apple[:email], account_type: params[:account_type]).first 

        if @user 
          params[:email] = @user.email
          params[:password] = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
          @user.password = @user.password_confirmation = params[:password]
          @user.save
          super
        else
          @user = User.new(sign_up_params)
          @user.email = apple[:email]
          @user.hideBirthdate = false 
          @user.hideBirthplace = false 
          @user.hideEmail = false 
          @user.hideAddress = false 
          @user.hidePhonenumber = false 
          @user.is_verified = true

          if @user.first_name == nil
            @user.first_name = "John"
            @user.last_name = "Doe #{@user.id}"
          end

          @user.save
          params[:email] = @user.email
          params[:password] = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
          @user.password = @user.password_confirmation = params[:password]
          @user.save
          super
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
      params.permit(:facebook_id, :google_id, :account_type, :first_name, :last_name, :phone_number, :email, :username)
    end

    protected

    def valid_params?(key, val)
      params[:facebook_id].present? || params[:google_id].present? ? "" : resource_params[:password] && key && val
    end
end