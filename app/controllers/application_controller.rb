class ApplicationController < ActionController::Base
        before_action :set_current_user 
        include DeviseTokenAuth::Concerns::SetUserByToken

        protect_from_forgery with: :null_session 

        rescue_from ActiveRecord::RecordNotFound, :with => :known_error
        rescue_from PG::UniqueViolation, :with => :same_email

        rescue_from CanCan::AccessDenied do |exception|
            render json: {status: exception.message}
        end
        
        def current_user
            super || guest_user
        end

        private

        def guest_user
            User.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_guest_user.id : session[:guest_user_id])
        end
      
        def create_guest_user
            u = User.create(:username => "guest", :email => "guest_#{Time.now.to_i}#{rand(99)}@example.com", :guest => true)
            u.save(:validate => false)
            u
        end
        
        def known_error(exception)
                return render json: {errors: exception}, status: 404
        end

        def same_email(exception)
            return render json: {errors: exception}, status: 406
        end

        def numberOfPage
            10
        end

        def user
            current_user
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
                SELECT id, 'Memorial' AS object_type, name, country, description FROM memorials
                UNION
                SELECT id, 'Blm' AS object_type, name, country, description FROM blms
            ) AS pages"
        end
        
        def relationship_sql
            "(
                SELECT id, page_type, page_id, user_id FROM relationships
                UNION
                SELECT id, page_type, page_id, user_id FROM followers
            ) AS relationship"
        end
        
        def set_current_user
            User.current = current_user
            # current_user != nil ? User.current = current_user : ""
        end
end
