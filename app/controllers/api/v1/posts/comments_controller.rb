class Api::V1::Posts::CommentsController < ApplicationController
    set_account_type = 1 ? (before_action :authenticate_user!) : (before_action :authenticate_alm_user!) 
    # before_action :no_guest_users, only: [:addComment, :addReply, :likeOrUnlike, :likeStatus]

    def editComment
        comment = Comment.find(params[:comment_id])

        comment.update(body: params[:body])
        comment.account = user()
        
        if comment
            render json: {status: :success, comment: comment}
        else
            render json: {status: comment.errors}
        end
    end

    def editReply
        reply = Reply.find(params[:reply_id])

        reply.update(body: params[:body])
        reply.account = user()
        
        if reply
            render json: {status: :success, reply: reply}
        else
            render json: {status: reply.errors}
        end
    end

    def addComment
        comment = Comment.new(comment_params)
        comment.account = user()
        if comment.save
            # Add to notification
                # For blm followers
                (comment.post.page.users.uniq - [user()]).each do |user|
                    if user.notifsetting.postComments == true
                        # check if user owns the post
                        if user == comment.post.account 
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on your post", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{user().first_name} commented on your post"
                            PushNotification(device_token, title, message, user, user(), comment.post.id, "Post", comment.post.page_type)
                        else comment.post.tagpeople.where(account: user).first
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on a post that you're tagged in", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{user().first_name} commented on a post that you're tagged in"
                            PushNotification(device_token, title, message, user, user(), comment.post.id, "Post", comment.post.page_type)
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
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on your post", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{user().first_name} commented on your post"
                            PushNotification(device_token, title, message, user, user(), comment.post.id, "Post", comment.post.page_type)
                        else comment.post.tagpeople.where(account: user).first
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on a post that you're tagged in", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{user().first_name} commented on a post that you're tagged in"
                            PushNotification(device_token, title, message, user, user(), comment.post.id, "Post", comment.post.page_type)
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
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on your post", postId: comment.post.id, read: false, notif_type: 'Post')
                                #Push Notification
                                device_token = user.device_token
                                title = "FacesbyPlaces Notification"
                                message = "#{user().first_name} commented on your post"
                                PushNotification(device_token, title, message, user, user(), comment.post.id, "Post", comment.post.page_type)
                            else comment.post.tagpeople.where(account: user).first
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on a post that you're tagged in", postId: comment.post.id, read: false, notif_type: 'Post')
                                #Push Notification
                                device_token = user.device_token
                                title = "FacesbyPlaces Notification"
                                message = "#{user().first_name} commented on a post that you're tagged in"
                                PushNotification(device_token, title, message, user, user(), comment.post.id, "Post", comment.post.page_type)
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
            if reply.comment.replies.count == 1
                if user() != reply.comment.account
                    if reply.comment.account.notifsetting.postComments == true
                        Notification.create(recipient: reply.comment.account, actor: user(), action: "#{user().first_name} replied to your comment", postId: reply.comment.post.id, read: false, notif_type: 'Post')
                        #Push Notification
                        device_token = reply.comment.account.device_token
                        title = "FacesbyPlaces Notification"
                        message = "#{user().first_name} replied to your comment"
                        PushNotification(device_token, title, message)
                    end
                end
            else
                users = reply.comment.accounts.uniq - [user()]
                if users.count == 0
                    if reply.comment.account.notifsetting.postComments == true
                        Notification.create(recipient: reply.comment.account, actor: user(), action: "#{user().first_name} replied to your comment", postId: reply.comment.post.id, read: false, notif_type: 'Post')
                        #Push Notification
                        device_token = reply.comment.account.device_token
                        title = "FacesbyPlaces Notification"
                        message = "#{user().first_name} replied to your comment"
                        PushNotification(device_token, title, message)
                    end
                else
                    users.each do |user|
                        if user.notifsetting.postComments == true
                            if reply.comment.account == user
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} replied to your comment", postId: reply.comment.post.id, read: false, notif_type: 'Post')
                                #Push Notification
                                device_token = user.device_token
                                title = "FacesbyPlaces Notification"
                                message = "#{user().first_name} replied to your comment"
                                PushNotification(device_token, title, message)
                            else
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} replied to a comment", postId: reply.comment.post.id, read: false, notif_type: 'Post')
                                #Push Notification
                                device_token = user.device_token
                                title = "FacesbyPlaces Notification"
                                message = "#{user().first_name} replied to a comment"
                                PushNotification(device_token, title, message)
                            end
                        end
                    end
                    
                end
            end

            render json: {status: :success, reply: reply}
        else
            render json: {status: comment.errors}, status: 500
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

    def commentsIndex
        post = Post.find(params[:id])
        comments = post.comments 

        comments = comments.page(params[:page]).per(numberOfPage)
        if comments.total_count == 0 || (comments.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif comments.total_count < numberOfPage
            itemsremaining = comments.total_count 
        else
            itemsremaining = comments.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        comments: ActiveModel::SerializableResource.new(
                                        comments, 
                                        each_serializer: CommentSerializer
                                    )
                    }
    end
    
    def repliesIndex
        comment = Comment.find(params[:id])
        replies = comment.replies 

        replies = replies.page(params[:page]).per(numberOfPage)
        if replies.total_count == 0 || (replies.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif replies.total_count < numberOfPage
            itemsremaining = replies.total_count 
        else
            itemsremaining = replies.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        replies: ActiveModel::SerializableResource.new(
                                    replies, 
                                    each_serializer: ReplySerializer
                                )
                    }
    end

    def deleteComment
        comment = Comment.find(params[:comment_id])

        if comment.account == user() || comment.account.guest == true
            comment.destroy 

            render json: {status: :destroy}, status: 200
        else
            render json: {status: "This is not your comment"}, status: 401
        end
    end

    def deleteReply
        reply = Reply.find(params[:reply_id])

        if reply.account == user() || comment.user.guest == true
            reply.destroy 

            render json: {status: :destroy}, status: 200
        else
            render json: {status: "This is not your reply"}, status: 401
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

    def like
        if Commentslike.where(account: user(), commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).first == nil
            like = Commentslike.new(comment_like_params)
            like.account = user()
            like.save 

            # Notification
            if like.commentable_type == "Comment"
                if like.commentable.account != user() && like.commentable.account.notifsetting.postLikes == true
                    Notification.create(recipient: like.commentable.account, actor: user(), action: "#{user().first_name} liked your comment", postId: like.commentable.post.id, read: false, notif_type: 'Post')
                    #Push Notification
                    device_token = like.commentable.account.device_token
                    title = "FacesbyPlaces Notification"
                    message = "#{user().first_name} liked your comment"
                    PushNotification(device_token, title, message)
                end
            else
                if like.commentable.account != user() && like.commentable.account.notifsetting.postLikes == true
                    Notification.create(recipient: like.commentable.account, actor: user(), action: "#{user().first_name} liked your reply", postId: like.commentable.comment.post.id, read: false, notif_type: 'Post')
                end
            end

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
    
end
