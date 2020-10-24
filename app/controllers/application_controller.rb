class ApplicationController < ActionController::Base
        include DeviseTokenAuth::Concerns::SetUserByToken

        protect_from_forgery with: :null_session

        rescue_from ActiveRecord::RecordNotFound, :with => :known_error
        rescue_from Pagy::OverflowError, :with => :lastPage
        

        private
        def known_error(exception)
                return render json: {errors: exception}
        end

        def lastPage
              return render json: {errors: 'Page not Found'}  
        end

        def numberOfPage
                2
        end

        def user
            User.first
        end
end
