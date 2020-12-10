class SearchmemorialSerializer < ActiveModel::Serializer
  attributes :id, :page 
  
  def page
    if object.searchable_type == "Blm" # BLM pages
      blm = Blm.find(object.searchable_id)
      ActiveModel::SerializableResource.new(
        blm, 
        each_serializer: BlmSerializer
      )
    else  # Memorial pages
      memorial = Memorial.find(object.searchable_id)
      ActiveModel::SerializableResource.new(
        memorial, 
        each_serializer: MemorialSerializer
      )
    end
  end
end
