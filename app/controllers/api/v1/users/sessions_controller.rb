class Api::V1::Users::SessionsController < DeviseTokenAuth::SessionsController

    def render_create_success
      user = @resource
      if user.is_verified?
        render json: { success: true, user:  user, status: 200 }, status: 200
      end
    end

    ## SIGN_IN AS GUEST
    def guest
      User.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_guest_user.id : session[:guest_user_id])
    end
    
    def create_guest_user
      u = User.create(:username => "guest", :email => "guest_#{Time.now.to_i}#{rand(99)}@example.com", :guest => true)
      u.save(:validate => false)
      render json: { success: true, user:  u, status: 200 }, status: 200
      u
    end
    ##

    def create
      #Facebook Login
      account_type = params[:account_type].to_i
      if params[:facebook_id].present?
        @user = AlmUser.where(email: params[:email], account_type: params[:account_type]).first # || BlmUser.where(email: params[:email], account_type: params[:account_type]).first

        if @user
          params[:password] = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
          @user.password = @user.password_confirmation = params[:password]
          @user.save
          super
        else
          if account_type == 1
            @user = User.new(sign_up_params)
          elsif account_type == 2
            @user = AlmUser.new(sign_up_params)
          end

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

          params[:password] = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
          @user.password = @user.password_confirmation = params[:password]
          @user.save

          Notifsetting.create(newMemorial: true, newActivities: true, postLikes: true, postComments: true, addFamily: true, addFriends: true, addAdmin: true, account: @user)
          super
        end

      #Google Login
      elsif params[:google_id].present?
        validator = GoogleIDToken::Validator.new
        required_audience = JWT.decode(params[:google_id], nil, false)[0]['aud'] 

        begin
          payload = validator.check(params[:google_id], required_audience, required_audience)
          @user = AlmUser.where(email: payload['email'], account_type: params[:account_type]).first # || BlmUser.where(email: payload['email'], account_type: params[:account_type]).first

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

          if account_type == 1
            @user = User.new(sign_up_params)
          elsif account_type == 2
            @user = AlmUser.new(sign_up_params)
          end

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

            Notifsetting.create(newMemorial: true, newActivities: true, postLikes: true, postComments: true, addFamily: true, addFriends: true, addAdmin: true, account: @user)
            super
          rescue GoogleIDToken::ValidationError => e
            return render json: {status: "Cannot validate: #{e}"}, status: 422
          end
        end

      # Apple Login
      elsif params[:user_identification].present? && params[:identity_token].present?
        apple = AppleAuth::UserIdentity.new(params[:user_identification], params[:identity_token]).validate!
        
        @user = AlmUser.where(email: apple[:email], account_type: params[:account_type]).first # || BlmUser.where(email: apple[:email], account_type: params[:account_type]).first

        if @user 
          params[:email] = @user.email
          params[:password] = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
          @user.password = @user.password_confirmation = params[:password]
          @user.save
          super
        else

          if account_type == 1
            @user = User.new(sign_up_params)
          elsif account_type == 2
            @user = AlmUser.new(sign_up_params)
          end

          @user.email = apple[:email]
          @user.hideBirthdate = false 
          @user.hideBirthplace = false 
          @user.hideEmail = false 
          @user.hideAddress = false 
          @user.hidePhonenumber = false 
          @user.is_verified = true

          @user.save

          if params[:first_name]
            @user.first_name = "John"
            @user.last_name = "Doe #{@user.id}"

            @user.save
          end

          params[:email] = @user.email
          params[:password] = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
          @user.password = @user.password_confirmation = params[:password]
          @user.save

          Notifsetting.create(newMemorial: true, newActivities: true, postLikes: true, postComments: true, addFamily: true, addFriends: true, addAdmin: true, account: @user)
          super
        end
        
      # Fbp Login
      else
        account_type = params[:account_type].to_i

        if account_type == 1
          user = BlmUser.find_by(email: params[:email])
        else
          user = AlmUser.find_by(email: params[:email])
        end 

        # Check if account exist or not
        if user == nil
          if account_type == 1
            return render json: { message: "BLM account not found. Register to login to the page.", status: 401 }, status: 401
          elsif account_type == 2
            return render json: { message: "ALM account not found. Register to login to the page.", status: 401 }, status: 401
          end
        end 

        if user.is_verified?
          super
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