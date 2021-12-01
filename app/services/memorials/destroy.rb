class Memorials::Destroy

    def initialize( memorial:, admins:, id:, type: )
        @memorial = memorial
        @admins   = admins
        @id       = id
        @type     = type
    end

    def execute
        deleteAdmins
        deleteNotifs
        
        @memorial.destroy
    end
    
    private

    def deleteAdmins
        if @type === "Blm"
            @admins.each do |admin_id|
                User.find(admin_id).roles.where(resource_type: 'Blm', resource_id: @id).first.destroy
            end
        else
            @admins.each do |admin_id|
                AlmUser.find(admin_id).roles.where(resource_type: 'Memorial', resource_id: @id).first.destroy 
            end
        end
    end

    def deleteNotifs
        @notifs = Notification.all.where(postId: @id, notif_type: @type)

        @notifs.each do |notif|
            notif.destroy
        end
    end
end