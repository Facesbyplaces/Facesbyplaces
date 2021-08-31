class Posts::Comments::Create

    def initialize( comment:, user: )
        @comment                = comment
        @user                   = user
    end

    def execute
        comment = Comment.new(@comment)
        comment.account = @user

        if Post.find(comment.post_id)
            if comment.save
                # Add to notification
                notify_followers_of_a_comment(comment)
                return true
            else
                return comment.errors
            end
        end
    end

    private

    def notify_followers_of_a_comment(comment)
        # For blm followers
        (comment.post.page.users.uniq - [@user]).each do |user|
            if user.notifsetting.postComments == true
                # check if user owns the post
                if user == comment.post.account 
                    Notification::Builder.new(
                        device_tokens:  user.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} commented on your post",
                        recipient:      user,
                        actor:          @user,
                        data:           comment.post.id,
                        type:           "Post",
                        postType:       comment.post.page_type,
                    ).notify
                else comment.post.tagpeople.where(account: user).first
                    Notification::Builder.new(
                        device_tokens:  user.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} commented on a post that you're tagged in",
                        recipient:      user,
                        actor:          @user,
                        data:           comment.post.id,
                        type:           "Post",
                        postType:       comment.post.page_type,
                    ).notify
                # else
                #     Notification.create(recipient: comment.post.account, actor: @user, action: "#{@user.first_name} commented on #{comment.post.account.first_name}'s post", postId: comment.post.id, read: false, notif_type: 'Post')
                #     #Push Notification
                #     device_token = user.device_token
                #     title = "FacesbyPlaces Notification"
                #     message = "#{@user.first_name} commented on #{comment.post.account.first_name}'s post"
                #     PushNotification(device_token, title, message)
                end

            end
        end

        # For alm followers
        (comment.post.page.alm_users.uniq - [@user]).each do |user|
            if user.notifsetting.postComments == true
                # check if user owns the post
                if user == comment.post.account 
                    Notification::Builder.new(
                        device_tokens:  user.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} commented on your post",
                        recipient:      user,
                        actor:          @user,
                        data:           comment.post.id,
                        type:           "Post",
                        postType:       comment.post.page_type,
                    ).notify
                else comment.post.tagpeople.where(account: user).first
                    Notification::Builder.new(
                        device_tokens:  user.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} commented on a post that you're tagged in",
                        recipient:      user,
                        actor:          @user,
                        data:           comment.post.id,
                        type:           "Post",
                        postType:       comment.post.page_type,
                    ).notify
                # else
                #     Notification.create(recipient: comment.post.account, actor: @user, action: "#{@user.first_name} commented on #{comment.post.account.first_name}'s post", postId: comment.post.id, read: false, notif_type: 'Post')
                #     #Push Notification
                #     device_token = user.device_token
                #     title = "FacesbyPlaces Notification"
                #     message = "#{@user.first_name} commented on #{comment.post.account.first_name}'s post"
                #     PushNotification(device_token, title, message)
                end
            end
        end

        # For families and friends
        (comment.post.page.relationships).each do |relationship|
            if relationship.account.notifsetting.postComments == true
                if relationship.account != @user
                    user = relationship.account

                    # check if user owns the post
                    if user == comment.post.account 
                        Notification::Builder.new(
                            device_tokens:  user.device_token,
                            title:          "FacesByPlaces Notification",
                            message:        "#{@user.first_name} commented on your post",
                            recipient:      user,
                            actor:          @user,
                            data:           comment.post.id,
                            type:           "Post",
                            postType:       comment.post.page_type,
                        ).notify
                    else comment.post.tagpeople.where(account: user).first
                        Notification::Builder.new(
                            device_tokens:  user.device_token,
                            title:          "FacesByPlaces Notification",
                            message:        "#{@user.first_name} commented on a post that you're tagged in",
                            recipient:      user,
                            actor:          @user,
                            data:           comment.post.id,
                            type:           "Post",
                            postType:       comment.post.page_type,
                        ).notify
                    end
                end
            end
        end
    end
end