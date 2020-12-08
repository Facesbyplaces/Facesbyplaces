class ApplicationController < ActionController::Base
        before_action :set_current_user 
        include DeviseTokenAuth::Concerns::SetUserByToken

        protect_from_forgery with: :null_session 

        rescue_from ActiveRecord::RecordNotFound, :with => :known_error

        rescue_from CanCan::AccessDenied do |exception|
            render json: {status: exception.message}
        end
        # # if user is logged in, return current_user, else return guest_user
        # def current_or_guest_user
        #     if current_user
        #     if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        #         logging_in
        #         # reload guest_user to prevent caching problems before destruction
        #         guest_user(with_retry = false).try(:reload).try(:destroy)
        #         session[:guest_user_id] = nil
        #     end
        #     current_user
        #     else
        #     guest_user
        #     end
        # end

        # # find guest_user object associated with the current session,
        # # creating one as needed
        # def guest_user(with_retry = true)
        #     # Cache the value the first time it's gotten.
        #     @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

        # rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
        #     session[:guest_user_id] = nil
        #     guest_user if with_retry
        # end

        def after_sign_in_path_for(resource)
            api_v1_mainpages_memorials_url
        end

        

        private

        # def logging_in
        #     # For example:
        #     # guest_comments = guest_user.comments.all
        #     # guest_comments.each do |comment|
        #       # comment.user_id = current_user.id
        #       # comment.save!
        #     # end
        #     pages.update_all(user_id: user.id)
        #     posts.update_all(user_id: user.id)
        # end

        # def create_guest_user
        #     u = User.new(:name => "guest", :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com")
        #     u.save!(:validate => false)
        #     session[:guest_user_id] = u.id
        #     u
        # end

        # def verify
        #     user = User.find(current_user.id)
        #     flash[:error] = "You must be logged in to access this section" unless user.is_verified?
        # end
        
        def known_error(exception)
                return render json: {errors: exception}, status: 404
        end

        def numberOfPage
            10
        end

        def user
            User.find(current_user.id)
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
        
        def set_current_user
            User.current.present? ? User.current = current_user : ""
        end
end
