class RelationshipSerializer < ActiveModel::Serializer
  attributes :page, :page_type

  def page
    if object.page.page_name == "blm" # BLM pages
      ActiveModel::SerializableResource.new(
        object.page, 
        each_serializer: BlmSerializer
      )
    else  # Memorial pages
      ActiveModel::SerializableResource.new(
        object.page, 
        each_serializer: MemorialSerializer
      )
    end
  end
  
end
