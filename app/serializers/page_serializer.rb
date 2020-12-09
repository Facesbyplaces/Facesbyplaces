class PageSerializer < ActiveModel::Serializer
  attributes :page 

  def page
    if object.page_type == 'Blm'
      blm = Blm.find(object.page_id)
      BlmSerializer.new( blm ).attributes
    else
      memorial = Memorial.find(object.page_id)
      MemorialSerializer.new( memorial ).attributes
    end
  end
end
