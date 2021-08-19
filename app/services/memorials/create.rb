class Memorials::Create

    def initialize( memorial:, user:, relationship:, type: )
        @memorial       = memorial
        @user           = user
        @relationship   = relationship
        @type           = type
    end

    def execute
        if @type === "Blm"
            memorial = Blm.new(@memorial)
        else
            memorial = Memorial.new(@memorial)
        end
        save_memorial(memorial, memorial.latitude, memorial.longitude)
    end

    def save_memorial(memorial, latitude, longitude)
        set_privacy(memorial)        
        memorial.save
        save_owner(memorial)
        update_location(memorial, latitude, longitude)
        save_relationship(memorial)
    end

    def set_privacy(memorial)
        memorial.privacy = "public"
        memorial.hideFamily = false
        memorial.hideFriends = false
        memorial.hideFollowers = false
    end

    def save_owner(memorial)
        if @type === "Blm"
            pageowner = Pageowner.new(account_type: "User", account_id: @user.id, view: 0)
            memorial.pageowner = pageowner
        else
            pageowner = Pageowner.new(account_type:  "AlmUser", account_id: @user.id, view: 0)
            memorial.pageowner = pageowner
        end
    end

    def update_location(memorial, latitude, longitude)
        memorial.update!(latitude: latitude, longitude: longitude)
    end

    def save_relationship(memorial)
        relationship = memorial.relationships.new(account: @user, relationship: @relationship)
        
        if relationship.save 
            set_admin(memorial)
            notify_users(memorial)
        end
    end

    def set_admin(memorial)
        @user.add_role "pageadmin", memorial
    end

    def notify_users(memorial)
        if @type === "Blm"
            blmUsers = User.joins(:notifsetting).where("notifsettings.newMemorial": true).where("notifsettings.account_type != 'User' AND notifsettings.account_id != #{@user.id}")
            almUsers = AlmUser.joins(:notifsetting).where("notifsettings.newMemorial": true)
        else
            blmUsers = User.joins(:notifsetting).where("notifsettings.newMemorial": true)
            almUsers = AlmUser.joins(:notifsetting).where("notifsettings.newMemorial": true).where("notifsettings.account_type != 'AlmUser' AND notifsettings.account_id != #{@user.id}")
        end

        blmUsers.each do |user|
            notification = Notification::Builder.new(
                device_tokens:  user.device_token,
                title:          "New Memorial Page",
                message:        "#{@user.first_name} created a new page",
                recipient:      user,
                actor:          @user,
                data:           memorial.id,
                type:           @type,
                postType:       @type,
            )
            notification.notify
        end

        almUsers.each do |user|
            notification = Notification::Builder.new(
                device_tokens:  user.device_token,
                title:          "New Memorial Page",
                message:        "#{@user.first_name} created a new page",
                recipient:      user,
                actor:          @user,
                data:           memorial.id,
                type:           @type,
                postType:       @type,
            )
            notification.notify
        end

    end
end