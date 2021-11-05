class Posts::Comments::Like
    require 'json'

    def initialize( user:, like: )
        @user = user
        @like = like
    end

    def execute
        like = Commentslike.new(@like)
        like.account = @user

        if like.save 
            # Add to notification
            notify_followers_of_a_like(like)

            return true
        else
            return like.errors
        end
    end

    private

    def notify_followers_of_a_like(like)
        if like.commentable_type == "Comment"
            if like.commentable.account != @user && like.commentable.account.notifsetting.postLikes == true
                Notification::Builder.new(
                        device_tokens:  like.commentable.account.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{user().first_name} liked your comment",
                        recipient:      like.commentable.account,
                        actor:          @user,
                        data:           like.commentable.post.id,
                        type:           "Post",
                        postType:       like.commentable.post.page_type,
                ).notify
            end
        else
            if like.commentable.account != user() && like.commentable.account.notifsetting.postLikes == true
                Notification::Builder.new(
                        device_tokens:  like.commentable.account.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{user().first_name} liked your reply",
                        recipient:      like.commentable.account,
                        actor:          user(),
                        data:           like.commentable.post.id,
                        type:           "Post",
                        postType:       like.commentable.post.page_type,
                ).notify
            end
        end
    end
end