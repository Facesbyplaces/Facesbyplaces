class BlmSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :details, :backgroundImage, :profileImage, :imagesOrVideos, :relationship, :page_creator, :privacy, :manage, :famOrFriends, :follower, :familyCount, :friendsCount, :postsCount, :followersCount, :page_type, :hideFamily, :hideFriends, :hideFollowers

  def details
    case object.privacy
    when "public"
      {
        description:  object.description,
        location:     object.location,
        precinct:     object.precinct,
        dob:          object.dob,
        rip:          object.rip,
        state:        object.state,
        country:      object.country
      }
    when "followers"
      if object.followers.where(user_id: object.currentUser.id).first || object.relationships.where(user_id: object.currentUser.id).first 
        {
          description:  object.description,
          location:     object.location,
          precinct:     object.precinct,
          dob:          object.dob,
          rip:          object.rip,
          state:        object.state,
          country:      object.country
        }
      end
    when "familyOrFriends"
      if object.relationships.where(user_id: object.currentUser.id).first 
        {
          description:  object.description,
          location:     object.location,
          precinct:     object.precinct,
          dob:          object.dob,
          rip:          object.rip,
          state:        object.state,
          country:      object.country
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
    object.backgroundImage.attached? ? url_for(object.backgroundImage) : "" 
  end

  def profileImage
    object.profileImage.attached? ? url_for(object.profileImage) : ""
  end

  def imagesOrVideos
    getImage(object.imagesOrVideos)
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

  def followersCount
    object.followers.count
  end

  def page_type
    "Blm"
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

  private
  def getImage(images)
    sendImages = []
    images.each do |image|
      sendImages.push(rails_blob_url(image))
    end
    return sendImages
  end
end
