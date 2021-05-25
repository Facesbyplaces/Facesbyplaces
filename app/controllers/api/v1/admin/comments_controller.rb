class Api::V1::Admin::CommentsController < ApplicationController
    before_action :check_user
    # before_action :no_guest_users, only: [:addComment, :addReply, :likeOrUnlike, :likeStatus]

    def editComment
        comment = Comment.find(params[:id])

        comment.update(body: edit_comment_params[:body])
        comment.account = user()
        
        if comment
            render json: {status: :success, comment: comment}
        else
            render json: {status: comment.errors}
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
                            PushNotification(device_token, title, message)
                        elsif comment.post.tagpeople.where(account: user).first
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on a post that you're tagged in", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{user().first_name} commented on a post that you're tagged in"
                            PushNotification(device_token, title, message)
                        else
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on #{comment.post.account.first_name}'s post", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{user().first_name} commented on #{comment.post.account.first_name}'s post"
                            PushNotification(device_token, title, message)
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
                            PushNotification(device_token, title, message)
                        elsif comment.post.tagpeople.where(account: user).first
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on a post that you're tagged in", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{user().first_name} commented on a post that you're tagged in"
                            PushNotification(device_token, title, message)
                        else
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on #{comment.post.account.first_name}'s post", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{user().first_name} commented on #{comment.post.account.first_name}'s post"
                            PushNotification(device_token, title, message)
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
                                PushNotification(device_token, title, message)
                            elsif comment.post.tagpeople.where(account: user).first
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on a post that you're tagged in", postId: comment.post.id, read: false, notif_type: 'Post')
                                #Push Notification
                                device_token = user.device_token
                                title = "FacesbyPlaces Notification"
                                message = "#{user().first_name} commented on a post that you're tagged in"
                                PushNotification(device_token, title, message)
                            else
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on #{User.find(comment.post.account_id).first_name}'s post", postId: comment.post.id, read: false, notif_type: 'Post')
                                #Push Notification
                                device_token = user.device_token
                                title = "FacesbyPlaces Notification"
                                message = "#{user().first_name} commented on #{comment.post.account.first_name}'s post"
                                PushNotification(device_token, title, message)
                            end
                        end
                    end
                end

            render json: {status: :success, comment: comment}
        else
            render json: {status: comment.errors}, status: 404
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

    def deleteComment
        comment = Comment.find(params[:id])
        comment.destroy 

        render json: {status: :destroy}, status: 200
    end

    private
    def comment_params
        params.permit(:post_id, :body)
    end

    def edit_comment_params
        params.require(:comment).permit(:body)
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

    def PushNotification(device_tokens, title, message)
        require 'fcm'
        puts        "\n-- Device Token : --\n#{device_tokens}"
        logger.info "\n-- Device Token : --\n#{device_tokens}"

        fcm_client = FCM.new(Rails.application.credentials.dig(:firebase, :server_key))
        options = { notification: { 
                        body: 'message',
                        title: 'title',
                    }
                }

        begin
            response = fcm_client.send(device_tokens, options)
        rescue StandardError => err
            puts        "\n-- PushNotification : Error --\n#{err}"
            logger.info "\n-- PushNotification : Error --\n#{err}"
        end

        puts response
    end

    
end
