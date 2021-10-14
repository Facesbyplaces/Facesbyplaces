class BlmSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :details, :backgroundImage, :profileImage, :imagesOrVideos, :relationship, :page_creator, :privacy, :manage, :famOrFriends, :follower, :familyCount, :friendsCount, :postsCount, :followersCount, :page_type, :hideFamily, :hideFriends, :hideFollowers

  def details
    case object.privacy
    when "public"
      {
        description:        object.description,
        location:           object.location,
        precinct:           object.precinct,
        dob:                object.dob.to_date,
        rip:                object.rip.to_date,
        state:              object.state,
        country:            object.country,
        longitude:          object.longitude,
        latitude:           object.latitude,
        accept_donations:   object.stripe_connect_account_id.present? ? true : false
      }
    when "followers"
      if object.currentUser
        if object.followers.where(account: object.currentUser).first || object.relationships.where(account: object.currentUser).first 
          {
            description:        object.description,
            location:           object.location,
            precinct:           object.precinct,
            dob:                object.dob.to_date,
            rip:                object.rip.to_date,
            state:              object.state,
            country:            object.country,
            longitude:          object.longitude,
            latitude:           object.latitude,
            accept_donations:   object.stripe_connect_account_id.present? ? true : false
          }
        end
      end
    when "familyOrFriends"
      if object.currentUser
        if object.relationships.where(account: object.currentUser).first 
          {
            description:        object.description,
            location:           object.location,
            precinct:           object.precinct,
            dob:                object.dob.to_date,
            rip:                object.rip.to_date,
            state:              object.state,
            country:            object.country,
            longitude:          object.longitude,
            latitude:           object.latitude,
            accept_donations:   object.stripe_connect_account_id.present? ? true : false
          }
        end
      end
    end
  end

  def manage
    if object.currentUser != nil
      if object.currentUser.has_role? :pageadmin, object
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def page_creator
    if object.pageowner
      ActiveModel::SerializableResource.new(
        object.pageowner.account, 
        each_serializer: UserSerializer
      )
    end
  end
   
  def backgroundImage
    if object.backgroundImage.present?
      # url_for(object.backgroundImage)
      ActiveStorage::Current.host = "https://facesbyplaces.com/"
      object.backgroundImage.service_url
    else
      return ""
    end
  end

  def profileImage
    if object.profileImage.present?
      # url_for(object.profileImage)
      ActiveStorage::Current.host = "https://facesbyplaces.com/"
      object.profileImage.service_url
    else
      return ""
    end
  end

  def imagesOrVideos
    if object.imagesOrVideos.present?
      getImage(object.imagesOrVideos)
    else
      return ""
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

  def followersCount
    object.followers.count
  end

  def page_type
    "Blm"
  end

  def relationship
    if object.relationships.where(account: object.currentUser).first
      object.relationships.where(account: object.currentUser).first.relationship
    elsif object.relationships.first
      object.relationships.first.relationship
    end
  end

  def famOrFriends
    if object.currentUser != nil && object.relationships.where(account: object.currentUser).first 
      return true
    elsif object.currentAlmUser != nil && object.relationships.where(account: object.currentAlmUser).first 
      return true
    else
      return false
    end
  end

  def follower
    if object.currentUser
      if object.currentUser.account_type == 1
        if object.users.where(id: object.currentUser.id).first
          return true
        end
      else
        if object.alm_users.where(id: object.currentUser.id).first
          return true
        end
      end
    end
    
    return false 
  end

  private
  def getImage(images)
    sendImages = []
    images.each do |image|
      ActiveStorage::Current.host = "https://facesbyplaces.com/"
      sendImages.push(image.service_url)
    end
    return sendImages
  end
end
