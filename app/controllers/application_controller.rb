class ApplicationController < ActionController::Base
        include DeviseTokenAuth::Concerns::SetUserByToken

        protect_from_forgery with: :null_session

        rescue_from ActiveRecord::RecordNotFound, :with => :known_error

        private
        def known_error(exception)
                return render json: {errors: exception}
        end
end
