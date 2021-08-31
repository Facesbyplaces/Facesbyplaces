class Api::V1::Admin::CommentsController < ApplicationController
    include Commentable
    before_action :admin_only
    before_action :set_users, only: [:usersSelection]
    before_action :set_comments, only: [:commentsIndex]
    before_action :set_search_comments, only: [:searchComment]
    before_action :set_comment, only: [:editComment, :deleteComment]
    before_action :set_actor, only: [:addComment, :editComment]

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
        comment = Posts::Comments::Create.new(comment: comment_params, user: @actor).execute

        if comment 
            render json: { status: :success, comment: Comment.last }
        else
            render json: { error: comment }, status: 400
        end
    end
    
    def editComment
        @comment.update(body: edit_comment_params[:body])
        @comment.account = @actor
        
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
end
