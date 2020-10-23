class Api::V1::Users::SessionsController < DeviseTokenAuth::SessionsController

    def render_create_success
      user = @resource
      render json: {
        success: true,
        user:  {
          id: user.id,
          email: user.email,
          username: user.username.to_s,
          name: user.full_name.to_s,
          image: user.image.attached? ? (request.base_url+url_for(user.image)) : "",
          phone_number: user.phone_number.to_s
        },
        status: 200
      }, status: 200
    end 
end