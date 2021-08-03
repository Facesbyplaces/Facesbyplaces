module Commentable
    include ApplicationConcern
  
    def set_comments
        post = Post.find(params[:id])
        comments = post.comments 
        @comments = comments.page(params[:page]).per(numberOfPage)
    end

    def set_replies
        comment = Comment.find(params[:id])
        replies = comment.replies
        @replies = replies.page(params[:page]).per(numberOfPage)
    end

    def set_comment
        @comment = Comment.find(params[:comment_id])
    end

    def set_reply
        @reply = Reply.find(params[:reply_id])
    end
end