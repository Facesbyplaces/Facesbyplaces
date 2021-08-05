class Api::V1::Admin::CommentsController < ApplicationController
    include Commentable
    before_action :admin_only
    before_action :set_users, only: [:usersSelection]
    before_action :set_comments, only: [:commentsIndex]
    before_action :set_search_comments, only: [:searchComment]
    before_action :set_comment, only: [:editComment, :deleteComment]

    def usersSelection #for create comment users selection
        render json: {success: true,  users: @users }, status: 200
    end

    def commentsIndex
        render json: {  itemsremaining:  itemsRemaining(@comments),
                        comments: ActiveModel::SerializableResource.new(
                            @comments, 
                            each_serializer: CommentSerializer
                        )
                    }
    end

    def searchComment
        render json: {  #itemsremaining:  itemsRemaining(@comments),
                        comments: ActiveModel::SerializableResource.new(
                            @search_comments, 
                            each_serializer: CommentSerializer
                        )
                    }
    end

    def addComment
        comment = Comment.new(comment_params)
        comment.account = userActor
        if comment.save
            notify_followers_of_a_comment(comment)
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

    def notify_followers_of_a_comment(comment, userActor)
        # For blm followers
        (comment.post.page.users.uniq - [userActor]).each do |user|
            if user.notifsetting.postComments == true
                # check if user owns the post
                if user == comment.post.account 
                    message = "#{userActor.first_name} commented on your post"
                    send_notif(user, userActor, message, comment)
                elsif comment.post.tagpeople.where(account: user).first
                    message = "#{userActor.first_name} commented on a post that you're tagged in"
                    send_notif(user, userActor, message, comment)
                else
                    message = "#{userActor.first_name} commented on #{comment.post.account.first_name}'s post"
                    send_notif(user, userActor, message, comment)
                end

            end
        end

        # For alm followers
        (comment.post.page.alm_users.uniq - [userActor]).each do |user|
            if user.notifsetting.postComments == true
                # check if user owns the post
                if user == comment.post.account 
                    message = "#{userActor.first_name} commented on your post"
                    send_notif(user, userActor, message, comment)
                elsif comment.post.tagpeople.where(account: user).first
                    message = "#{userActor.first_name} commented on a post that you're tagged in"
                    send_notif(user, userActor, message, comment)
                else
                    message = "#{userActor.first_name} commented on #{comment.post.account.first_name}'s post"
                    send_notif(user, userActor, message, comment)
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
                        message = "#{userActor.first_name} commented on your post"
                        send_notif(user, userActor, message, comment)
                    elsif comment.post.tagpeople.where(account: user).first
                        message = "#{userActor.first_name} commented on a post that you're tagged in"
                        send_notif(user, userActor, message, comment)
                    else
                        message = "#{userActor.first_name} commented on #{comment.post.account.first_name}'s post"
                        send_notif(user, userActor, message, comment)
                    end
                end
            end
        end
    end

    def send_notif(user, userActor, message, comment)
        Notification.create(recipient: user, actor: userActor, action: message, postId: comment.post.id, read: false, notif_type: 'Post')
        #Push Notification
        device_token = user.device_token
        title = "FacesbyPlaces Notification"
        PushNotification(device_token, title, message, user, userActor, comment.post.id, "Post", comment.post.page_type)
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
