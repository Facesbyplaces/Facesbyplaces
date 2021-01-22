class Api::V1::Users::PasswordsController < DeviseTokenAuth::PasswordsController

    protected

    def render_update_success
      render json: {
       data: resource_data(resource_json: @resource.token_validation_response),
       message: I18n.t('devise_token_auth.passwords.successfully_updated')
      }, scope: :current_master
    end

end