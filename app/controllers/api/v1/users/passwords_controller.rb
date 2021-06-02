class Api::V1::Users::PasswordsController < DeviseTokenAuth::PasswordsController
    before_action :check_user

    def update
      user().update(password_update: true)
      super
    end
    
    protected

    def render_update_success
      render json: {
       data: resource_data(resource_json: @resource.token_validation_response),
       message: I18n.t('devise_token_auth.passwords.successfully_updated')
      }, scope: :current_master
    end

end