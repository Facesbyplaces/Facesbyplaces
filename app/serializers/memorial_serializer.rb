class MemorialSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :details, :backgroundImage, :profileImage, :imagesOrVideos, :relationship, :page_creator, :manage, :famOrFriends, :follower, :familyCount, :friendsCount, :postsCount, :followersCount, :page_type, :hideFamily, :hideFriends, :hideFollowers

  def details
    case object.privacy
    when "public"
      {
        description:    object.description,
        birthplace:     object.birthplace,
        dob:            object.dob,
        rip:            object.rip,
        cemetery:       object.cemetery,
        country:        object.country
      }
    when "followers"
      if object.followers.where(user_id: object.currentUser.id).first || object.relationships.where(user_id: object.currentUser.id).first 
        {
          description:    object.description,
          birthplace:     object.birthplace,
          dob:            object.dob,
          rip:            object.rip,
          cemetery:       object.cemetery,
          country:        object.country
        }
      end
    when "familyOrFriends"
      if object.relationships.where(user_id: object.currentUser.id).first 
        {
          description:    object.description,
          birthplace:     object.birthplace,
          dob:            object.dob,
          rip:            object.rip,
          cemetery:       object.cemetery,
          country:        object.country
        }
      end
    end
  end

  def manage
    if object.currentUser
      if object.currentUser.has_role? :pageadmin, object 
        return true
      end
    end
    
    return false 
  end

  def page_creator
    ActiveModel::SerializableResource.new(
      object.pageowner.user, 
      each_serializer: UserSerializer
    )
  end
  
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

  def familyCount
    object.relationships.count - object.relationships.where(relationship: 'Friend').count
  end

  def friendsCount
    object.relationships.where(relationship: 'Friend').count
  end

  def postsCount
    object.posts.count
  end

  def relationship
    if object.relationships.where(user: object.currentUser).first
      object.relationships.where(user: object.currentUser).first.relationship
    end
  end

  def famOrFriends
    if object.currentUser == nil
      return false 
    end
    if object.relationships.where(user_id: object.currentUser.id).first
      return true
    end
    
    return false 
  end

  def follower
    if object.currentUser
      if object.users.where(id: object.currentUser.id).first
        return true
      end
    end
    
    return false 
  end

  def followersCount
    object.followers.count
  end

  def page_type
    "Memorial"
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
