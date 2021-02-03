class Api::V1::Admin::SessionsController < DeviseTokenAuth::SessionsController

  def sign_in_params
    params.require(:admin).permit(:email, :password)
  end

  def render_create_success
    admin = @resource
    render json: {
      success: true,
      loggedIn: true,
      admin:  {
        id: admin.id,
        email: admin.email,
        full_name: admin.full_name
      },
      status: 200
    }, status: 200
  end 
end