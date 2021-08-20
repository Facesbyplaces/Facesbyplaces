class Api::V1::Posts::CommentsController < ApplicationController
    include Commentable
    before_action :authenticate_user
    before_action :set_comments, only: [:commentsIndex]
    before_action :set_replies, only: [:repliesIndex]
    before_action :set_comment, only: [:editComment, :deleteComment]
    before_action :set_reply, only: [:editReply, :deleteReply]
    # before_action :no_guest_users, only: [:addComment, :addReply, :likeOrUnlike, :likeStatus]

    def addComment
        comment = Posts::Comments::Create.new(comment: comment_params, user: user()).execute

        if comment 
            render json: { status: :success, comment: Comment.last }
        else
            render json: { error: comment }, status: 400
        end
    end

    def addReply
        reply = Posts::Comments::Replies::Create.new(reply: reply_params, user: user()).execute
        
        if reply
            render json: { status: :success, reply: Reply.last }
        else
            render json: { error: reply }
        end 
    end

    def editComment
        @comment.update(body: params[:body])
        @comment.account = user()
        
        return render json: {status: @comment.errors} unless @comment
        render json: {status: :success, comment: @comment}
    end

    def editReply
        @reply.update(body: params[:body])
        @reply.account = user()
        
        return render json: {status: @reply.errors} unless @reply
        render json: {status: :success, reply: @reply}
    end

    def commentsIndex
        render json: {  itemsremaining:  itemsRemaining(@comments),
                        comments: ActiveModel::SerializableResource.new(
                                        @comments, 
                                        each_serializer: CommentSerializer
                                    )
                    }
    end
    
    def repliesIndex
        render json: {  itemsremaining:  itemsRemaining(@replies),
                        replies: ActiveModel::SerializableResource.new(
                                    @replies, 
                                    each_serializer: ReplySerializer
                                )
                    }
    end

    def deleteComment
        return render json: {status: "This is not your comment"}, status: 401 unless @comment.account == user() || @comment.account.guest == true
        @comment.destroy 

        render json: {status: :destroy}, status: 200
    end

    def deleteReply
        return render json: {status: "This is not your reply"}, status: 401 unless @reply.account == user() || @comment.user.guest == true
        @reply.destroy 
        
        render json: {status: :destroy}, status: 200
    end

    def likeStatus
        numberOfLikes = Commentslike.where(commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).count
  
        # case params[:commentable_type]
        # when 'Comment'
        #     comment = Comment.find(params[:commentable_id])
        # when 'Reply'
        #     comment = Reply.find(params[:commentable_id])
        # end
        
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

    def notif_type
        return "Post"
    end

    def like
        return render json: {}, status: 409 unless Commentslike.where(account: user(), commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).first == nil
        like = Commentslike.new(comment_like_params)
        like.account = user()
        like.save 

        notify_followers_of_a like

        render json: {}, status: 200
    end
    
    def unlike
        return render json: {}, status: 404 unless Commentslike.where(account: user(), commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).first != nil
        unlike = Commentslike.where(account: user(), commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).first 
        return render json: {}, status: 500 unless unlike.destroy 
        
        render json: {}, status: 200
    end

    def notify_followers_of_a like
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
