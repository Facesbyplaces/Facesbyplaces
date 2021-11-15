class RelationshipSerializer < ActiveModel::Serializer
  attributes :user, :relationship, :pageowner

  def user
    ActiveModel::SerializableResource.new(
      object.account, 
      each_serializer: UserSerializer
    )
  end

  def pageowner
    user.pageowners{ |pageowner| 
      return true if pageowner.page_id == object.page_id
    }
  end

end
