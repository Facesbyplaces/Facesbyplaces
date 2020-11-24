class BlmSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :details, :backgroundImage, :profileImage, :imagesOrVideos, :relationship, :page_creator, :privacy, :manage

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
    if object.currentUser == nil
      return false 
    end
    if object.currentUser.has_role? :pageadmin, object 
      return true
    end
    
    return false 
  end

  def page_creator
    object.pageowner.user
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

  # relationship
  def relationship
    if object.relationships.where(user: object.currentUser).first
      object.relationships.where(user: object.currentUser).first.relationship
    end
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