class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :provider, :uid, :allow_password_change, :first_name, :last_name, :phone_number, :email, :username, :verification_code, :is_verified, :created_at, :updated_at, :guest, :account_type, :image, :question, :birthdate, :birthplace, :address, :device_token

  def image
    if object.image.attached?
      rails_blob_url(object.image)
    end
  end
end
