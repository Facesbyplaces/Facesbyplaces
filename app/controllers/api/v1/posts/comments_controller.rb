class Api::V1::Posts::CommentsController < ApplicationController
    before_action :authenticate_user!

    def addComment
        comment = Comment.new(comment_params)
        comment.user = user()
        if comment.save
            NotificationBroadcastJob.perform_later(comment)
            render json: {status: "Added Comment"}
        else
            render json: {status: "Error"}
        end
    end
    
    def addReply
        reply = Reply.new(reply_params)
        reply.user = user()
        if reply.save 
            NotificationBroadcastJob.perform_later(reply)
            render json: {status: "Added Reply"}
        else
            render json: {status: "Error"}
        end
    end

    def like
        like = Commentslike.new(comment_like_params)
        like.user = user()
        like.save 
        render json: {status: "Liked Comment"}
    end
    
    def unlike
        unlike = Commentslike.where("commentable_type = '#{params[:commentable_type]}' AND commentable_id = #{params[:commentable_id]} AND user_id = #{user().id}").first 
        unlike.destroy 
        render json: {status: "Unliked Comment"}
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
    
end
