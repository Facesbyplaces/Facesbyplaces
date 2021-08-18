class PostSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :page, :body, :location, :latitude, :longitude, :imagesOrVideos, :user, :tag_people, :created_at, :numberOfLikes, :numberOfComments, :likeStatus

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
    tags = object.tagpeople.collect do |person|
      # if person.account_type == 1
      #   person = User.find(person.account_id)
      # else
      #   person = AlmUser.find(person.account_id)
      # end

      ActiveModel::SerializableResource.new(
        person.account, 
        each_serializer: UserSerializer
      )
    end

    return tags
  end

  def user
    ActiveModel::SerializableResource.new(
      object.account, 
      each_serializer: UserSerializer
    )
  end

  def likeStatus
    if object.postslikes.where(account: object.currentUser).first
      true
    else
      false
    end
  end

  def numberOfLikes
    object.postslikes.count
  end

  def numberOfComments
    commentsCount = object.comments.count 
    repliesCount = object.comments.joins(:replies).count 
    commentsCount + repliesCount
  end

  private
  def getImage(images)
    sendImages = []
    images.each do |image|
      sendImages.push(url_for(image))
    end
    return sendImages
  end
end
