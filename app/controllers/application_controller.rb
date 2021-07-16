class ApplicationController < ActionController::Base
        include DeviseTokenAuth::Concerns::SetUserByToken

        protect_from_forgery with: :null_session 

        rescue_from ActiveRecord::RecordNotFound, :with => :known_error
        rescue_from Stripe::InvalidRequestError, :with => :invalid_stripe_transaction
        # rescue_from PG::UniqueViolation, :with => :same_email

        rescue_from CanCan::AccessDenied do |exception|
            render json: {status: exception.message}
        end
      
        private

        def set_account_type
            if params[:account_type] === "1"
                return 1
            else
                return 2
            end
        end

        def guest_user
            User.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_guest_user.id : session[:guest_user_id]) || AlmUser.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_guest_user.id : session[:guest_user_id])
        end
       
        def create_guest_user
            u = User.create(:username => "guest", :first_name => "guest", :email => "guest_#{Time.now.to_i}#{rand(99)}@example.com", :guest => true) || AlmUser.create(:username => "guest", :first_name => "guest", :email => "guest_#{Time.now.to_i}#{rand(99)}@example.com", :guest => true)
            u.save(:validate => false)
            u
        end
        
        def known_error(exception)
            return render json: {errors: exception}, status: 400
        end

        def invalid_stripe_transaction
            return render json: {errors: "Token is invalid or has been used twice"}, status: 400
        end

        def same_email(exception)
            return render json: {errors: exception}, status: 406
        end

        def numberOfPage
            10
        end

        def params_presence(data)
            # list of optional parameters
            list = ['description', 'backgroundImage', 'imagesOrVideos', 'profileImage', 'precinct']
            data.each do |key, datum|
                if !list.include?(key)
                    if datum == ""
                        return key
                    end
                end
            end
            return true
        end
        
        def pages_sql
            "(
                SELECT id, 'Memorial' AS object_type FROM memorials
                UNION
                SELECT id, 'Blm' AS object_type FROM blms
            ) AS pages"
        end
        
        def relationship_sql
            "(
                SELECT id, page_type, page_id, account_type, account_id FROM relationships
                UNION
                SELECT id, page_type, page_id, account_type, account_id FROM followers
            ) AS relationship"
        end

        def user_sql
            "(
                SELECT id, 'BlmUser' AS user_type FROM users
                UNION
                SELECT id, 'AlmUser' AS user_type FROM alm_users
            ) AS user"
        end

        def is_guest_user?
            # Someone is logged in AND (we have a guest id AND that id matches the current user)
            current_user && (session[:guest_user_id] && session[:guest_user_id] == current_user.id)
        end

        def no_guest_users
            if user().guest == true 
                return render json: {error: "pls login"}, status: 422
            end
        end
        
        def PushNotification(device_tokens, title, message, recipient, actor, data, type, postType)
            require 'fcm'
            puts        "\n-- Device Token : --\n#{device_tokens}"
            logger.info "\n-- Device Token : --\n#{device_tokens}"
    
            fcm_client = FCM.new(Rails.application.credentials.dig(:firebase, :server_key))
            options = { 
                "notification": { 
                    "title": title,    
                    "body": message,
                },
                "data": {
                    "recipient": recipient,
                    "actor": actor,
                    "dataID": data,
                    "dataType": type,
                    "postType": postType
                }
            }
    
            begin
                response = fcm_client.send(device_tokens, options)
            rescue StandardError => err
                puts        "\n-- PushNotification : Error --\n#{err}"
                logger.info "\n-- PushNotification : Error --\n#{err}"
            end
    
            puts response
        end
end
