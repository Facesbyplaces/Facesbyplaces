class Api::V1::Posts::CommentsController < ApplicationController
    before_action :authenticate_user!

    def addComment
        comment = Comment.new(comment_params)
        comment.user = user()
        if comment.save
            # Add to notification
                # For followers
                (comment.post.page.users.uniq - [user()]).each do |user|
                    if user.notifsetting.postComments == true
                        # check if user owns the post
                        if user == comment.post.user 
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on your post", postId: comment.post.id, read: false)
                        elsif comment.post.tagpeople.where(user_id: user.id).first
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on a post that you're tagged in", postId: comment.post.id, read: false)
                        else
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on #{comment.post.user.first_name}'s post", postId: comment.post.id, read: false)
                        end
                    end
                end

                # For families and friends
                (comment.post.page.relationships).each do |relationship|
                    if relationship.user.notifsetting.postComments == true
                        if relationship.user != user()
                            user = relationship.user
                            # check if user owns the post
                            if user == comment.post.user 
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on your post", postId: comment.post.id, read: false)
                            elsif comment.post.tagpeople.where(user_id: user.id).first
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on a post that you're tagged in", postId: comment.post.id, read: false)
                            else
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on #{comment.post.user.first_name}'s post", postId: comment.post.id, read: false)
                            end
                        end
                    end
                end

            render json: {status: :success}
        else
            render json: {status: comment.errors}
        end
    end
    
    def addReply
        reply = Reply.new(reply_params)
        reply.user = user()
        if reply.save 
            # Add to notification
            if reply.comment.replies.count == 1
                if user() != reply.comment.user
                    if reply.comment.user.notifsetting.postComments == true
                        Notification.create(recipient: reply.comment.user, actor: user(), action: "#{user().first_name} replied to your comment", postId: reply.comment.post.id, read: false)
                    end
                end
            else
                users = reply.comment.users.uniq - [user()]
                if users.count == 0
                    if reply.comment.user.notifsetting.postComments == true
                        Notification.create(recipient: reply.comment.user, actor: user(), action: "#{user().first_name} replied to your comment", postId: reply.comment.post.id, read: false)
                    end
                else
                    users.each do |user|
                        if user.notifsetting.postComments == true
                            if reply.comment.user == user
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} replied to your comment", postId: eply.comment.post.id, read: false)
                            else
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} replied to a comment", postId: reply.comment.post.id, read: false)
                            end
                        end
                    end
                end
            end

            render json: {status: :success}
        else
            render json: {status: comment.errors}, status: 500
        end
    end

    def like
        if Commentslike.where(user: user(), commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).first == nil
            like = Commentslike.new(comment_like_params)
            like.user = user()
            like.save 

            # Notification
            if like.commentable_type == "Comment"
                if like.commentable.user != user() && like.commentable.user.notifsetting.postLikes == true
                    Notification.create(recipient: like.commentable.user, actor: user(), action: "#{user().first_name} liked your comment", postId: like.commentable.post.id, read: false)
                end
            else
                if like.commentable.user != user() && like.commentable.user.notifsetting.postLikes == true
                    Notification.create(recipient: like.commentable.user, actor: user(), action: "#{user().first_name} liked your reply", postId: like.commentable.comment.post.id, read: false)
                end
            end

            render json: {}, status: 200
        else
            render json: {}, status: 409
        end
    end
    
    def unlike
        if Commentslike.where(user: user(), commentable_type: params[:commentable_type], commentable_id: params[:commentable_id]).first != nil
            unlike = Commentslike.where("commentable_type = '#{params[:commentable_type]}' AND commentable_id = #{params[:commentable_id]} AND user_id = #{user().id}").first 
             if unlike.destroy 
                render json: {}, status: 200
             else
                render json: {}, status: 500
             end
        else
            render json: {}, status: 404
        end
    end

    def commentsIndex
        post = Post.find(params[:id])
        comments = post.comments 

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
    
    def repliesIndex
        comment = Comment.find(params[:id])
        replies = comment.replies 

        replies = replies.page(params[:page]).per(numberOfPage)
        if replies.total_count == 0 || (replies.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif replies.total_count < numberOfPage
            itemsremaining = replies.total_count 
        else
            itemsremaining = replies.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        replies: ActiveModel::SerializableResource.new(
                                    replies, 
                                    each_serializer: ReplySerializer
                                )
                    }
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
