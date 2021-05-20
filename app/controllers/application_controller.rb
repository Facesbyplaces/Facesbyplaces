class ApplicationController < ActionController::Base
        before_action :set_current_user 
        include DeviseTokenAuth::Concerns::SetUserByToken

        protect_from_forgery with: :null_session 

        rescue_from ActiveRecord::RecordNotFound, :with => :known_error
        rescue_from Stripe::InvalidRequestError, :with => :invalid_stripe_transaction
        # rescue_from PG::UniqueViolation, :with => :same_email

        rescue_from CanCan::AccessDenied do |exception|
            render json: {status: exception.message}
        end
      
        private

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

        def user
            current_alm_user || current_user
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
        
        
        def set_current_user
            AlmUser.current = current_alm_user || User.current = current_user
            # current_user != nil ? User.current = current_user : ""
        end

        def check_user
            if user() != nil   
                if user().account_type == 1 || "1" 
                    return :authenticate_user!  
                else
                    return :authenticate_alm_user! 
                end
            else
                return render json: {error: "Account is needed to proceed."}, status: 404
            end
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
        
end
