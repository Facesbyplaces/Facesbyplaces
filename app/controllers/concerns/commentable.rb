module Commentable
    include ApplicationConcern
  
    def set_users
        if params[:page_type].to_i == 2
            @users = AlmUser.all 
        else
            @users = User.all.where.not(guest: true, username: "admin")
        end
    end
    
    def set_comments
        post = Post.find(params[:id])
        comments = post.comments 
        @comments = comments.page(params[:page]).per(numberOfPage)
    end

    def set_search_comments
        commentsId = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Comment').pluck('searchable_id')
        c = Comment.where(id: commentsId)
        @search_comments = []

        c.map{ |comment| 
            if comment.post.id == params[:page_id].to_i
                @search_comments.push(comment)
            end
        }

        @search_comments
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