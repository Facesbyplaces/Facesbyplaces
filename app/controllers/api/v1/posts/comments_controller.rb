class Api::V1::Posts::CommentsController < ApplicationController
    include Commentable
    before_action :authenticate_user
    before_action :set_comments, only: [:commentsIndex]
    before_action :set_comments2, only: [:commentsIndex2]
    before_action :set_replies, only: [:repliesIndex]
    before_action :set_replies2, only: [:repliesIndex2]
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

    def commentsIndex2
        render json: {  
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

    def repliesIndex2
        render json: {  
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
            return render json: {}, status: 400 unless Commentslike.where(account: user(), commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).first == nil
            like = Posts::Comments::Like.new( user: user(), like: comment_like_params ).execute

            if like 
                render json: { }, status: 200 
            else 
                render json: { errors: like }, status: 400
            end
        else
            return render json: {}, status: 404 unless Commentslike.where(account: user(), commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).first != nil
            unlike = Commentslike.where(account: user(), commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).first 
            
            if unlike.destroy 
                render json: { }, status: 200 
            else
                render json: {}, status: 500
            end
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
    
end
