class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :page, :sender, :owner, :amount, :status, :created_at

  def page
    if object.page_type == 'Blm'
      blm = Blm.find(object.page_id)
      BlmSerializer.new( blm ).attributes
    else
      memorial = Memorial.find(object.page_id)
      MemorialSerializer.new( memorial ).attributes
    end
  end

  def sender
    UserSerializer.new( object.account ).attributes
  end

  def owner
    if object.page_type == 'Blm'
      blm = Blm.find(object.page_id)
      UserSerializer.new( blm.pageowner.account ).attributes
    else
      memorial = Memorial.find(object.page_id)
      UserSerializer.new( memorial.pageowner.account ).attributes
    end
  end
end
