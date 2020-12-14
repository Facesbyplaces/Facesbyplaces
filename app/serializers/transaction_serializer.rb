class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :page, :user, :amount, :created_at

  def page
    if object.page_type == 'Blm'
      blm = Blm.find(object.page_id)
      BlmSerializer.new( blm ).attributes
    else
      memorial = Memorial.find(object.page_id)
      MemorialSerializer.new( memorial ).attributes
    end
  end

  def user
    UserSerializer.new( object.user ).attributes
  end
end
