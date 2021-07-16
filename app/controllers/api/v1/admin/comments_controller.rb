class Api::V1::Admin::CommentsController < ApplicationController
    set_account_type = 1 ? (before_action :authenticate_user!) : (before_action :authenticate_alm_user!) 
    before_action :admin_only

    def usersSelection #for create comment users selection
        users = User.all.where.not(guest: true, username: "admin")
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
            send_notif(comment, userActor)
            render json: {status: :success, comment: comment}
        else
            render json: {status: comment.errors}, status: 404
        end
    end

    def commentsIndex
        post = Post.find(params[:id])
        comments = post.comments 

        render_comments(comments)
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
        
        render_comments(comments)
    end

    private
    def comment_params
        params.require(:comment).permit(:post_id, :body)
    end

    def edit_comment_params
        params.require(:comment).permit(:body)
    end

    def send_notif(comment, userActor)
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
                        PushNotification(device_token, title, message, user, userActor, comment.post.id, "Post", comment.post.page_type)
                    elsif comment.post.tagpeople.where(account: user).first
                        Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on a post that you're tagged in", postId: comment.post.id, read: false, notif_type: 'Post')
                        #Push Notification
                        device_token = user.device_token
                        title = "FacesbyPlaces Notification"
                        message = "#{userActor.first_name} commented on a post that you're tagged in"
                        PushNotification(device_token, title, message, user, userActor, comment.post.id, "Post", comment.post.page_type)
                    else
                        Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on #{comment.post.account.first_name}'s post", postId: comment.post.id, read: false, notif_type: 'Post')
                        #Push Notification
                        device_token = user.device_token
                        title = "FacesbyPlaces Notification"
                        message = "#{userActor.first_name} commented on #{comment.post.account.first_name}'s post"
                        PushNotification(device_token, title, message, user, userActor, comment.post.id, "Post", comment.post.page_type)
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
                        PushNotification(device_token, title, message, user, userActor, comment.post.id, "Post", comment.post.page_type)
                    elsif comment.post.tagpeople.where(account: user).first
                        Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on a post that you're tagged in", postId: comment.post.id, read: false, notif_type: 'Post')
                        #Push Notification
                        device_token = user.device_token
                        title = "FacesbyPlaces Notification"
                        message = "#{userActor.first_name} commented on a post that you're tagged in"
                        PushNotification(device_token, title, message, user, userActor, comment.post.id, "Post", comment.post.page_type)
                    else
                        Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on #{comment.post.account.first_name}'s post", postId: comment.post.id, read: false, notif_type: 'Post')
                        #Push Notification
                        device_token = user.device_token
                        title = "FacesbyPlaces Notification"
                        message = "#{userActor.first_name} commented on #{comment.post.account.first_name}'s post"
                        PushNotification(device_token, title, message, user, userActor, comment.post.id, "Post", comment.post.page_type)
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
                            PushNotification(device_token, title, message, user, userActor, comment.post.id, "Post", comment.post.page_type)
                        elsif comment.post.tagpeople.where(account: user).first
                            Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on a post that you're tagged in", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{userActor.first_name} commented on a post that you're tagged in"
                            PushNotification(device_token, title, message, user, userActor, comment.post.id, "Post", comment.post.page_type)
                        else
                            Notification.create(recipient: user, actor: userActor, action: "#{userActor.first_name} commented on #{User.find(comment.post.account_id).first_name}'s post", postId: comment.post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{userActor.first_name} commented on #{comment.post.account.first_name}'s post"
                            PushNotification(device_token, title, message, user, userActor, comment.post.id, "Post", comment.post.page_type)
                        end
                    end
                end
            end
    end
    
    def render_comments(comments)
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

    def admin_only
        if !current_user.has_role? :admin 
            return render json: {status: "Must be an admin to continue"}, status: 401
        end
    end
    
end
