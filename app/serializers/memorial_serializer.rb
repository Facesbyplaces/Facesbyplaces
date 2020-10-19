class MemorialSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :birthplace, :dob, :rip, :cemetery, :country, :name, :description, :backgroundImage, :profileImage, :imagesOrVideos, :relationship

  def backgroundImage
    if object.backgroundImage.attached?
      {
        url: rails_blob_url(object.backgroundImage)
      }
    end
  end

  def profileImage
    if object.profileImage.attached?
      {
        url: rails_blob_url(object.profileImage)
      }
    end
  end

  def imagesOrVideos
    if object.imagesOrVideos.attached?
      getImage(object.imagesOrVideos)
    end
  end

  # relationship
  def relationship
    object.memorialUserRelationships.where(user_id: user_id).first.relationship
  end

  private
  def getImage(images)
    sendImages = []
    images.each do |image|
      sendImages.push(rails_blob_url(image))
    end
    return sendImages
  end

  def user_id
    1
  end
end
