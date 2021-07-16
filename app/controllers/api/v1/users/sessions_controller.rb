class Api::V1::Users::SessionsController < DeviseTokenAuth::SessionsController
    after_action :set_account_type

    def create
      #Facebook Login
      if params[:facebook_id].present?
        @user = existing_user
        if @user
          if params[:password].present? 
            @user.update({ device_token: params[:device_token] })
            @user.save
            render json: { success: true, user:  @user, status: 200 }, status: 200
            super
          else
            params[:password] = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
            puts "Password: "
            puts params[:password]
            @user.password = @user.password_confirmation = params[:password]
            @user.update({ device_token: params[:device_token] })
            @user.save
            render json: { success: true, user:  @user, status: 200 }, status: 200
            super
          end
        else # If user's first login
          sign_up_user
          super
        end
      
      #Google Login
      elsif params[:google_id].present?
        if valid_token
          @user = existing_user
          if @user
            params[:email] = @user.email
            if params[:password].present? 
              @user.update({ device_token: params[:device_token] })
              @user.save
              render json: { success: true, user:  @user, status: 200 }, status: 200
              super
            else
              params[:password] = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
              @user.password = @user.password_confirmation = params[:password]
              @user.update({ device_token: params[:device_token] })
              @user.save
              render json: { success: true, user:  @user, status: 200 }, status: 200
              super
            end
          else
            sign_up_user
            super
          end
        else
          return render json: {status: "Cannot validate: Invalid Token"}, status: 422
        end

      # Apple Login
      elsif params[:user_identification].present? && params[:identity_token].present?
        apple = AppleAuth::UserIdentity.new(params[:user_identification], params[:identity_token]).validate!
        
        if params[:account_type] == "2"
          @user = AlmUser.where(email: apple[:email], account_type: params[:account_type]).first 
        else
          @user = User.where(email: apple[:email], account_type: params[:account_type]).first
        end

        if @user 
          params[:email] = @user.email
          params[:password] = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
          @user.password = @user.password_confirmation = params[:password]
          @user.update({ device_token: params[:device_token] })
          @user.save
          render json: { success: true, user:  @user, status: 200 }, status: 200
          super
        else
          sign_up_user
          super
        end
        
      # Fbp Login
      else
        @user = existing_user

        if @user.is_verified?
          @user.update({ device_token: params[:device_token] })
          super || render_create_success2 && super
        elsif @user == nil
          if params[:account_type] === "1"
            return render json: { message: "BLM account not found. Register to login to the page.", status: 401 }, status: 401
          else
            return render json: { message: "ALM account not found. Register to login to the page.", status: 401 }, status: 401
          end
        else 
          render json: {
              message: "Verify email to login to the app.",
          }, status: 401
        end
      end
    end
    
    private

    def sign_up_params
      params.permit(:facebook_id, :google_id, :account_type, :first_name, :last_name, :phone_number, :email, :username)
    end

    def valid_params?(key, val)
      params[:facebook_id].present? || params[:google_id].present? ? "" : resource_params[:password] && key && val
    end

    def render_create_success
      # render json: { success: true, user:  user, status: 200 }, status: 200
    end

    def render_create_success2
      render json: { success: true, user:  @user, status: 200 }, status: 200
    end

    def valid_token
      require 'google/apis/oauth2_v2'
      oauth2 = Google::Apis::Oauth2V2::Oauth2Service.new
      id_token = params[:google_id]

      begin
        userinfo = oauth2.tokeninfo(id_token: id_token)
        return true
      rescue Google::Apis::ClientError
        return false
      end
    end

    def existing_user
      email = params[:email]
      
      if params[:account_type] == "1" 
        return user = User.where(email: email, account_type: params[:account_type]).first 
      else
        return user = AlmUser.where(email: email, account_type: params[:account_type]).first
      end
    end  

    def sign_up_user
      if params[:account_type] === "1"
        @user = User.new(sign_up_params)
      else
        @user = AlmUser.new(sign_up_params)
      end

      @user.update({ device_token: params[:device_token] })
      @user.hideBirthdate = false 
      @user.hideBirthplace = false 
      @user.hideEmail = false 
      @user.hideAddress = false 
      @user.hidePhonenumber = false 
      @user.is_verified = true

      # image
      if params[:image].present? 
        require 'open-uri'
        downloaded_image = URI.open(params[:image])
        filename = File.basename(URI.parse(params[:image]).path)
        @user.image.attach(io: downloaded_image  , filename: filename)
      end

      params[:password] = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
      @user.password = @user.password_confirmation = params[:password]
      @user.save!
      render json: { success: true, user:  @user, status: 200 }, status: 200

      Notifsetting.create(newMemorial: true, newActivities: true, postLikes: true, postComments: true, addFamily: true, addFriends: true, addAdmin: true, account: @user)
    end

    
end