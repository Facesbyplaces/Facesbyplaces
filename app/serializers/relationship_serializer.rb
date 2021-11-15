class RelationshipSerializer < ActiveModel::Serializer
  attributes :user, :relationship, :pageowner

  def user
    ActiveModel::SerializableResource.new(
      object.account, 
      each_serializer: UserSerializer
    )
  end

  def pageowner
    if object.account.pageowners.where(page_type: object.page_type, page_id: object.page_id).first
        return true
    else
        return false
    end
  end

end
