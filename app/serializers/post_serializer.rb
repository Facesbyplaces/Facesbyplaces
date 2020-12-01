class PostSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :page, :body, :location, :latitude, :longitude, :imagesOrVideos, :user, :tag_people, :created_at

  def imagesOrVideos
    if object.imagesOrVideos.attached?
      getImage(object.imagesOrVideos)
    end
  end

  def page
    if object.page.page_name == "blm" # BLM pages
      ActiveModel::SerializableResource.new(
        object.page, 
        each_serializer: BlmSerializer
      )
    else  # Memorial pages
      ActiveModel::SerializableResource.new(
        object.page, 
        each_serializer: MemorialSerializer
      )
    end
  end

  def tag_people
    object.users
  end

  private
  def getImage(images)
    sendImages = []
    images.each do |image|
      sendImages.push(rails_blob_url(image))
    end
    return sendImages
  end
end
