class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :recipient_id, :actor, :read, :action, :postId

  def actor
    UserSerializer.new( object.actor ).attributes
  end
end
