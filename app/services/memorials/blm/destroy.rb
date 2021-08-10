class Memorials::Blm::Destroy

    def initialize( memorial:, admins:, id: )
        @memorial   = memorial
        @admins     = admins
        @id         = id
    end

    def execute
        @admins.each do |admin_id|
            User.find(admin_id).roles.where(resource_type: 'Blm', resource_id: @id).first.destroy
        end
        
        @memorial.destroy()
    end
    
    
end