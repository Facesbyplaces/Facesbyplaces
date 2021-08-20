class Posts::Comments::Replies::Create

    def initialize( reply:, user: )
        @reply                  = reply
        @user                   = user
    end

    def execute
        reply = Reply.new(@reply)
        reply.account = @user

        if Comment.find(reply.comment_id)
            if reply.save
                # Add to notification
                notify_followers_of_a_reply(reply)
                return true
            else
                return reply.errors
            end
        end
    end

    private

    def notify_followers_of_a_reply(reply)
        if reply.comment.replies.count == 1
            if @user != reply.comment.account
                if reply.comment.account.notifsetting.postComments == true
                    Notification::Builder.new(
                        device_tokens:  reply.comment.account.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} replied to your comment",
                        recipient:      reply.comment.account,
                        actor:          @user,
                        data:           reply.comment.post.id,
                        type:           "Post",
                        postType:       reply.comment.post.page_type,
                    ).notify
                end
            end
        else
            users = reply.comment.accounts.uniq - [@user]
            if users.count == 0
                if reply.comment.account.notifsetting.postComments == true
                    Notification::Builder.new(
                        device_tokens:  reply.comment.account.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} replied to your comment",
                        recipient:      reply.comment.account,
                        actor:          @user,
                        data:           reply.comment.post.id,
                        type:           "Post",
                        postType:       reply.comment.post.page_type,
                    ).notify
                end
            else
                users.each do |user|
                    if user.notifsetting.postComments == true
                        if reply.comment.account == user
                            Notification::Builder.new(
                                device_tokens:  reply.comment.account.device_token,
                                title:          "FacesByPlaces Notification",
                                message:        "#{@user.first_name} replied to your comment",
                                recipient:      reply.comment.account,
                                actor:          @user,
                                data:           reply.comment.post.id,
                                type:           "Post",
                                postType:       reply.comment.post.page_type,
                            ).notify
                        else
                            Notification::Builder.new(
                                device_tokens:  reply.comment.account.device_token,
                                title:          "FacesByPlaces Notification",
                                message:        "#{@user.first_name} replied to your comment",
                                recipient:      reply.comment.account,
                                actor:          @user,
                                data:           reply.comment.post.id,
                                type:           "Post",
                                postType:       reply.comment.post.page_type,
                            ).notify
                        end
                    end
                end
                
            end
        end
    end
    
end