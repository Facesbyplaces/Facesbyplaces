class RelationshipSerializer < ActiveModel::Serializer
  attributes :user, :relationship

  def user
    ActiveModel::SerializableResource.new(
      object.user, 
      each_serializer: UserSerializer
    )
  end
end
