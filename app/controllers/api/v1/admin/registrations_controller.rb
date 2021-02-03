class Api::V1::Admin::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def sign_up_params
    params.permit(:email, :full_name, :password, :password_confirmation)
  end
  
  def render_create_success
    admin = @resource
    render json: {
      success: true,
      admin:  {
        id: admin.id,
        email: admin.email,
        name: admin.full_name.to_s,
        # image: admin.image.attached? ? (request.base_url+url_for(admin.image)) : "",
      },
      status: "created"
    }, status: 200
  end 
end