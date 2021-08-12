class Notifsettings::Update

    def initialize( user:, setting:, type: )
        @user           = user
        @setting        = setting
        @type           = type
    end

    def execute
        case @type
        when "memorial"
            @user.notifsetting.update(newMemorial: @setting)
        when "activities"
            @user.notifsetting.update(newActivities: @setting)
        when "likes"
            @user.notifsetting.update(postLikes: @setting)
        when "comments"
            @user.notifsetting.update(postComments: @setting)
        when "family"
            @user.notifsetting.update(addFamily: @setting)
        when "friends"
            @user.notifsetting.update(addFriends: @setting)
        when "admin"
            @user.notifsetting.update(addAdmin: @setting)
        end
    end
    
    
end