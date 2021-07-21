class Api::V1::Posts::CommentsController < ApplicationController
    before_action :authenticate_user
    before_action :set_comment, only: [:editComment, :deleteComment]
    before_action :set_reply, only: [:editReply, :deleteReply]
    # before_action :no_guest_users, only: [:addComment, :addReply, :likeOrUnlike, :likeStatus]

    def addComment
        comment = Comment.new(comment_params)
        comment.account = user()

        if comment.save
            # Add to notification
            notify_followers_of_a_comment(comment)
            render json: {status: :success, comment: comment}
        else
            render json: {status: comment.errors}, status: 404
        end
    end

    def addReply
        reply = Reply.new(reply_params)
        reply.account = user()

        if reply.save 
            # Add to notification
            notify_followers_of_a_reply(reply)
            render json: {status: :success, reply: reply}
        else
            render json: {status: comment.errors}, status: 500
        end
    end

    def editComment
        @comment.update(body: params[:body])
        @comment.account = user()
        
        if @comment
            render json: {status: :success, comment: @comment}
        else
            render json: {status: @comment.errors}
        end
    end

    def editReply
        @reply.update(body: params[:body])
        @reply.account = user()
        
        if @reply
            render json: {status: :success, reply: @reply}
        else
            render json: {status: @reply.errors}
        end
    end

    def commentsIndex
        @comments = comments_index

        render json: {  itemsremaining:  itemsRemaining(@comments),
                        comments: ActiveModel::SerializableResource.new(
                                        @comments, 
                                        each_serializer: CommentSerializer
                                    )
                    }
    end
    
    def repliesIndex
        @replies = replies_index

        render json: {  itemsremaining:  itemsRemaining(@replies),
                        replies: ActiveModel::SerializableResource.new(
                                    @replies, 
                                    each_serializer: ReplySerializer
                                )
                    }
    end

    def deleteComment
        if @comment.account == user() || @comment.account.guest == true
            @comment.destroy 

            render json: {status: :destroy}, status: 200
        else
            render json: {status: "This is not your comment"}, status: 401
        end
    end

    def deleteReply
        if @reply.account == user() || @comment.user.guest == true
            @reply.destroy 

            render json: {status: :destroy}, status: 200
        else
            render json: {status: "This is not your reply"}, status: 401
        end
    end

    def likeStatus
        numberOfLikes = Commentslike.where(commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).count
        
        case params[:commentable_type]
        when 'Comment'
            comment = Comment.find(params[:commentable_id])
        when 'Reply'
            comment = Reply.find(params[:commentable_id])
        end
        
        if Commentslike.where(account: user(), commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).first
            render json: {
                like: true,
                numberOfLikes: numberOfLikes
                }, status: 200
        else
            render json: {
                like: false,
                numberOfLikes: numberOfLikes
                }, status: 200
        end
    end

    def likeOrUnlike
        if params[:like].downcase == 'true'
            like()
        else
            unlike()
        end
    end

    private
    def comment_params
        params.permit(:post_id, :body)
    end

    def reply_params
        params.permit(:comment_id, :body)
    end

    def comment_like_params
        params.permit(:commentable_type, :commentable_id)
    end

    def set_comment
        @comment = Comment.find(params[:comment_id])
    end

    def set_reply
        @reply = Reply.find(params[:reply_id])
    end

    def notif_type
        @notif_type = "Post"
    end

    def like
        if Commentslike.where(account: user(), commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).first == nil
            like = Commentslike.new(comment_like_params)
            like.account = user()
            like.save 

            # Add to notification
            notify_followers_of_a_like(like)

            render json: {}, status: 200
        else
            render json: {}, status: 409
        end
    end
    
    def unlike
        if Commentslike.where(account: user(), commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).first != nil
            unlike = Commentslike.where(account: user(), commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).first 
             if unlike.destroy 
                render json: {}, status: 200
             else
                render json: {}, status: 500
             end
        else
            render json: {}, status: 404
        end
    end

    def notify_followers_of_a_comment(comment)
        # For blm followers
        (comment.post.page.users.uniq - [user()]).each do |user|
            if user.notifsetting.postComments == true
                # check if user owns the post
                if user == comment.post.account 
                    message = "#{user().first_name} commented on your post"
                    send_notif(user, message, comment, @notif_type)
                else comment.post.tagpeople.where(account: user).first
                    message = "#{user().first_name} commented on a post that you're tagged in"
                    send_notif(user, message, comment, @notif_type)
                # else
                #     Notification.create(recipient: comment.post.account, actor: user(), action: "#{user().first_name} commented on #{comment.post.account.first_name}'s post", postId: comment.post.id, read: false, notif_type: 'Post')
                #     #Push Notification
                #     device_token = user.device_token
                #     title = "FacesbyPlaces Notification"
                #     message = "#{user().first_name} commented on #{comment.post.account.first_name}'s post"
                #     PushNotification(device_token, title, message)
                end

            end
        end

        # For alm followers
        (comment.post.page.alm_users.uniq - [user()]).each do |user|
            if user.notifsetting.postComments == true
                # check if user owns the post
                if user == comment.post.account 
                    message = "#{user().first_name} commented on your post"
                    send_notif(user, message, comment, @notif_type)
                else comment.post.tagpeople.where(account: user).first
                    message = "#{user().first_name} commented on a post that you're tagged in"
                    send_notif(user, message, comment, @notif_type)
                # else
                #     Notification.create(recipient: comment.post.account, actor: user(), action: "#{user().first_name} commented on #{comment.post.account.first_name}'s post", postId: comment.post.id, read: false, notif_type: 'Post')
                #     #Push Notification
                #     device_token = user.device_token
                #     title = "FacesbyPlaces Notification"
                #     message = "#{user().first_name} commented on #{comment.post.account.first_name}'s post"
                #     PushNotification(device_token, title, message)
                end
            end
        end

        # For families and friends
        (comment.post.page.relationships).each do |relationship|
            if relationship.account.notifsetting.postComments == true
                if relationship.account != user()
                    user = relationship.account

                    # check if user owns the post
                    if user == comment.post.account 
                        message = "#{user().first_name} commented on your post"
                        send_notif(user, message, comment, @notif_type)
                    else comment.post.tagpeople.where(account: user).first
                        message = "#{user().first_name} commented on a post that you're tagged in"
                        send_notif(user, message, comment, @notif_type)
                    # else
                    #     Notification.create(recipient: comment.post.account, actor: user(), action: "#{user().first_name} commented on #{comment.post.account.first_name}'s post", postId: comment.post.id, read: false, notif_type: 'Post')
                    #     #Push Notification
                    #     device_token = user.device_token
                    #     title = "FacesbyPlaces Notification"
                    #     message = "#{user().first_name} commented on #{comment.post.account.first_name}'s post"
                    #     PushNotification(device_token, title, message)
                    end
                end
            end
        end
    end

    def notify_followers_of_a_reply(reply)
        if reply.comment.replies.count == 1
            if user() != reply.comment.account
                if reply.comment.account.notifsetting.postComments == true
                    message = "#{user().first_name} replied to your comment"
                    send_notif(reply.comment.account, message, reply.comment, notif_type)
                end
            end
        else
            users = reply.comment.accounts.uniq - [user()]
            if users.count == 0
                if reply.comment.account.notifsetting.postComments == true
                    message = "#{user().first_name} replied to your comment"
                    send_notif(reply.comment.account, message, reply.comment, notif_type)
                end
            else
                users.each do |user|
                    if user.notifsetting.postComments == true
                        if reply.comment.account == user
                            message = "#{user().first_name} replied to your comment"
                            send_notif(user, message, reply.comment, notif_type)
                        else
                            message = "#{user().first_name} replied to a comment"
                            send_notif(user, message, reply.comment, notif_type)
                        end
                    end
                end
                
            end
        end
    end

    def notify_followers_of_a_like(like)
        if like.commentable_type == "Comment"
            if like.commentable.account != user() && like.commentable.account.notifsetting.postLikes == true
                message = "#{user().first_name} liked your comment"
                send_notif(like.commentable.account, message, like.commentable, notif_type)
            end
        else
            if like.commentable.account != user() && like.commentable.account.notifsetting.postLikes == true
                message = "#{user().first_name} liked your reply"
                send_notif(like.commentable.account, message, like.commentable.comment, notif_type)
            end
        end
    end

    def send_notif(recipient, message, action, notif_type)        
        Notification.create(recipient: recipient, actor: user(), action: message, postId: action.post.id, read: false, notif_type: notif_type)
        
        #Push Notification
        device_token = recipient.device_token
        title = "FacesbyPlaces Notification"
        PushNotification(device_token, title, message, recipient, user(), action.post.id, notif_type, action.post.page_type)
    end

    def comments_index
        post = Post.find(params[:id])
        comments = post.comments 

        return comments = comments.page(params[:page]).per(numberOfPage)
    end

    def replies_index
        comment = Comment.find(params[:id])
        replies = comment.replies 

        return replies = replies.page(params[:page]).per(numberOfPage)
    end

    def itemsRemaining(data)
        if data.total_count == 0 || (data.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif data.total_count < numberOfPage
            itemsremaining = data.total_count 
        else
            itemsremaining = data.total_count - (params[:page].to_i * numberOfPage)
        end
    end
    
end
