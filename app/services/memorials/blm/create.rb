class Memorials::Blm::Create

    def initialize( memorial:, user:, relationship: )
        @memorial       = memorial
        @user           = user
        @relationship   = relationship
    end

    def execute
        blm = Blm.new(@memorial)
        save_blm(blm)
        blm.save
    end

    def save_blm(blm)
        set_privacy(blm)
        save_owner(blm)
        update_location(blm)
        save_relationship(blm)
    end

    def set_privacy(blm)
        blm.privacy = "public"
        blm.hideFamily = false
        blm.hideFriends = false
        blm.hideFollowers = false
    end

    def save_owner(blm)
        pageowner = Pageowner.new(account_type: "User", account_id: @user.id, view: 0)
        blm.pageowner = pageowner
    end

    def update_location(blm)
        blm.update(latitude: blm.latitude, longitude: blm.longitude)
    end

    def save_relationship(blm)
        relationship = blm.relationships.new(account: @user, relationship: @relationship)
        
        if relationship.save 
            set_admin(blm)
            notify_users(blm)
        end
    end

    def set_admin(blm)
        @user.add_role "pageadmin", blm
    end

    def notify_users(blm)
        blmUsers = User.joins(:notifsetting).where("notifsettings.newMemorial": true).where("notifsettings.account_type != 'User' AND notifsettings.account_id != #{@user.id}")
        almUsers = AlmUser.joins(:notifsetting).where("notifsettings.newMemorial": true)
        
        blmUsers.each do |user|
            notification = Notification::Builder.new(
                device_tokens:  user.device_token,
                title:          "New Memorial Page",
                message:        "#{@user.first_name} created a new page",
                recipient:      user,
                actor:          @user,
                data:           blm.id,
                type:           'Blm',
                postType:       " ",
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
                data:           blm.id,
                type:           'Blm',
                postType:       " ",
            )
            notification.notify
        end

    end
end