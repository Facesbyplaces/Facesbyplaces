class ReplySerializer < ActiveModel::Serializer
  attributes :id, :comment_id, :user, :body, :created_at, :updated_at

  def user
    ActiveModel::SerializableResource.new(
      object.account, 
      each_serializer: UserSerializer
    )
  end
end
