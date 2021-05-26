class Api::V1::Admin::CommentsController < ApplicationController
    before_action :check_user
    # before_action :no_guest_users, only: [:addComment, :addReply, :likeOrUnlike, :likeStatus]

    def usersSelection #for create comment users selection
        users = User.all.where.not(guest: true, username: "admin")
        # _except(User.guest).order("users.id DESC")
        alm_users = AlmUser.all

        allUsers = users.order("users.id DESC") + alm_users.order("alm_users.id DESC")
        render json: {success: true,  users: allUsers }, status: 200
    end
    
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
        userActor = User.find(params[:user_id])
        comment = Comment.new(comment_params)
        comment.account = userActor
        if comment.save
            # Add to notification
                # For blm followers
                (comment.post.page.users.uniq - [userActor]).each do |user|
                    if user.notifsetting.postComments == true
                        # check if user owns the post
                        if user == comment.post.account 
                            Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on your post", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{userActor.first_name} commented on your post"
                            PushNotification(device_token, title, message)
                        elsif comment.post.tagpeople.where(account: user).first
                            Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on a post that you're tagged in", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{userActor.first_name} commented on a post that you're tagged in"
                            PushNotification(device_token, title, message)
                        else
                            Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on #{comment.post.account.first_name}'s post", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{userActor.first_name} commented on #{comment.post.account.first_name}'s post"
                            PushNotification(device_token, title, message)
                        end

                    end
                end

                # For alm followers
                (comment.post.page.alm_users.uniq - [userActor]).each do |user|
                    if user.notifsetting.postComments == true
                        # check if user owns the post
                        if user == comment.post.account 
                            Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on your post", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{userActor.first_name} commented on your post"
                            PushNotification(device_token, title, message)
                        elsif comment.post.tagpeople.where(account: user).first
                            Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on a post that you're tagged in", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{userActor.first_name} commented on a post that you're tagged in"
                            PushNotification(device_token, title, message)
                        else
                            Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on #{comment.post.account.first_name}'s post", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{userActor.first_name} commented on #{comment.post.account.first_name}'s post"
                            PushNotification(device_token, title, message)
                        end
                    end
                end

                # For families and friends
                (comment.post.page.relationships).each do |relationship|
                    if relationship.account.notifsetting.postComments == true
                        if relationship.account != userActor
                            user = relationship.account

                            # check if user owns the post
                            if user == comment.post.account 
                                Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on your post", postId: comment.post.id, read: false, notif_type: 'Post')
                                #Push Notification
                                device_token = user.device_token
                                title = "FacesbyPlaces Notification"
                                message = "#{userActor.first_name} commented on your post"
                                PushNotification(device_token, title, message)
                            elsif comment.post.tagpeople.where(account: user).first
                                Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on a post that you're tagged in", postId: comment.post.id, read: false, notif_type: 'Post')
                                #Push Notification
                                device_token = user.device_token
                                title = "FacesbyPlaces Notification"
                                message = "#{userActor.first_name} commented on a post that you're tagged in"
                                PushNotification(device_token, title, message)
                            else
                                Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on #{User.find(comment.post.account_id).first_name}'s post", postId: comment.post.id, read: false, notif_type: 'Post')
                                #Push Notification
                                device_token = user.device_token
                                title = "FacesbyPlaces Notification"
                                message = "#{userActor.first_name} commented on #{comment.post.account.first_name}'s post"
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

    def searchComment
        commentsId = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Comment').pluck('searchable_id')
        puts commentsId
        comments = Comment.where(id: commentsId)
        
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

    private
    def comment_params
        params.require(:comment).permit(:post_id, :body)
    end

    def edit_comment_params
        params.require(:comment).permit(:body)
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
