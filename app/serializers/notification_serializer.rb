class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :recipient, :actor, :read, :action, :postId, :notif_type

  def actor
    UserSerializer.new( object.actor ).attributes
  end

  def recipient
    UserSerializer.new( object.recipient ).attributes
  end
end
