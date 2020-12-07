class CommentSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :user, :body, :created_at, :updated_at

  def user
    ActiveModel::SerializableResource.new(
      object.user, 
      each_serializer: UserSerializer
    )
  end
end
