class Api::V1::Users::PasswordsController < DeviseTokenAuth::PasswordsController
    def render_update_success
        render json: {
        success: true,
        data: resource_data,
        message: I18n.t('devise_token_auth.passwords.successfully_updated')
        }
    end

end