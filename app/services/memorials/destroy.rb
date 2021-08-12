class Memorials::Destroy

    def initialize( memorial:, admins:, id:, type: )
        @memorial   = memorial
        @admins     = admins
        @id         = id
        @type       = type
    end

    def execute
        if @type === "Blm"
            @admins.each do |admin_id|
                User.find(admin_id).roles.where(resource_type: 'Blm', resource_id: @id).first.destroy
            end
        else
            @admins.each do |admin_id|
                AlmUser.find(admin_id).roles.where(resource_type: 'Memorial', resource_id: @id).first.destroy 
            end
        end
        
        @memorial.destroy()
    end
    
    
end