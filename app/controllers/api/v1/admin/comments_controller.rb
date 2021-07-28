class Api::V1::Admin::CommentsController < ApplicationController
    before_action :admin_only
    before_action :set_comment, only: [:editComment, :deleteComment]

    def usersSelection #for create comment users selection
        if params[:page_type].to_i == 2
            users = AlmUser.all 
        else
            users = User.all.where.not(guest: true, username: "admin")
        end

        render json: {success: true,  users: users }, status: 200
    end

    def commentsIndex
        @comments = fetched_comments

        render json: {  itemsremaining:  itemsRemaining(@comments),
                        comments: ActiveModel::SerializableResource.new(
                            @comments, 
                            each_serializer: CommentSerializer
                        )
                    }
    end

    def searchComment
        puts comments
        render json: {  #itemsremaining:  itemsRemaining(@comments),
                        comments: ActiveModel::SerializableResource.new(
                            comments, 
                            each_serializer: CommentSerializer
                        )
                    }
    end

    def addComment
        
        comment = Comment.new(comment_params)
        comment.account = userActor
        if comment.save
            send_notif(comment, userActor)
            render json: {status: :success, comment: comment}
        else
            render json: {status: comment.errors}, status: 404
        end
    end
    
    def editComment
        @comment.update(body: edit_comment_params[:body])
        @comment.account = user()
        
        if @comment
            render json: {status: :success, comment: @comment}
        else
            render json: {status: @comment.errors}
        end
    end  

    def deleteComment
        @comment.destroy 

        render json: {status: :destroy}, status: 200
    end 

    private
    def comment_params
        params.require(:comment).permit(:post_id, :body)
    end

    def edit_comment_params
        params.require(:comment).permit(:body)
    end

    def admin_only
        unless user().has_role? :admin 
            return render json: {status: "Must be an admin to continue"}, status: 401
        end
    end

    def userActor
        if params[:page_type].to_i == 1
            return User.find(params[:user_id])
        else 
            return AlmUser.find(params[:user_id])
        end
    end

    def comments
        commentsId = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Comment').pluck('searchable_id')
        c = Comment.where(id: commentsId)
        comments = []

        c.map{ |comment| 
            if comment.post.id == params[:page_id].to_i
                comments.push(comment)
            end
        }

        return comments
    end

    def set_comment
        @comment = Comment.find(params[:id])
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
    
    def fetched_comments
        post = Post.find(params[:id])
        comments = post.comments 

        return comments = comments.page(params[:page]).per(numberOfPage)
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
