class CommentsController < ApplicationController
    def addComment
        comment = Comment.new(comment_params)
        comment.user = user()
        if comment.save
            render json: {status: "Added Comment"}
        else
            render json: {status: "Error"}
        end
    end

    private
    def comment_params
        params.permit(:post_id, :body)
    end
end
