class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :provider, :uid, :allow_password_change, :first_name, :last_name, :phone_number, :email, :username, :verification_code, :is_verified, :created_at, :updated_at, :guest, :account_type, :image, :question, :security_answer, :birthdate, :birthplace, :address, :device_token

  def image
    if object.image.attached?
      ActiveStorage::Current.host = "https://facesbyplaces.com/"
      object.image.service_url
    else
      return ""
    end
  end

  def birthdate
    if object.hideBirthdate 
      return ""
    else
      object.birthdate
    end
  end

  def birthplace
    if object.hideBirthplace
      return ""
    else
      object.birthplace
    end
  end

  def email
    if object.hideEmail
      return ""
    else
      object.email
    end
  end

  def address
    if object.hideAddress
      return ""
    else
      object.address
    end
  end

  def phone_number
    if object.hidePhonenumber
      return ""
    else
      object.phone_number
    end
  end
end
