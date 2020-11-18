class Api::V1::Users::SessionsController < DeviseTokenAuth::SessionsController

    def render_create_success
      user = @resource
      if user.is_verified?
        render json: {
          success: true,
          user:  {
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
      if user.is_verified?
          super
      else
         render json: {
            message: "Verify email to login to the app.",
         }, status: 200
      end
    end
end