class Api::V1::Posts::CommentsController < ApplicationController
    before_action :authenticate_user!

    def addComment
        comment = Comment.new(comment_params)
        comment.user = user()
        if comment.save
            # Add to notification
                # For followers
                (comment.post.page.users.uniq - [user()]).each do |user|
                    # check if user owns the post
                    if user == comment.post.user 
                        Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on your post", url: "posts/#{comment.post.id}", read: false)
                    elsif comment.post.tagpeople.where(user_id: user.id).first
                        Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on a post that you're tagged in", url: "posts/#{comment.post.id}", read: false)
                    else
                        Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on #{comment.post.user.first_name}'s post", url: "posts/#{comment.post.id}", read: false)
                    end
                end

                # For families and friends
                (comment.post.page.relationships).each do |relationship|
                    if !relationship.user == user()
                        user = relationship.user
                        # check if user owns the post
                        if user == comment.post.user 
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on your post", url: "posts/#{comment.post.id}", read: false)
                        elsif comment.post.tagpeople.where(user_id: user.id).first
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on a post that you're tagged in", url: "posts/#{comment.post.id}", read: false)
                        else
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} commented on #{comment.post.user.first_name}'s post", url: "posts/#{comment.post.id}", read: false)
                        end
                    end
                end

            render json: {status: "Added Comment"}
        else
            render json: {status: "Error"}
        end
    end
    
    def addReply
        reply = Reply.new(reply_params)
        reply.user = user()
        if reply.save 
            # Add to notification
            if reply.comment.replies.count == 1
                if user() != reply.comment.user
                    Notification.create(recipient: reply.comment.user, actor: user(), action: "#{user().first_name} replied to your comment", url: "posts/#{reply.comment.post.id}", read: false)
                end
            else
                users = reply.comment.users.uniq - [user()]
                if users.count == 0
                    Notification.create(recipient: reply.comment.user, actor: user(), action: "#{user().first_name} replied to your comment", url: "posts/#{reply.comment.post.id}", read: false)
                else
                    users.each do |user|
                        if reply.comment.user == user
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} replied to your comment", url: "posts/#{reply.comment.post.id}", read: false)
                        else
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} replied to a comment", url: "posts/#{reply.comment.post.id}", read: false)
                        end
                    end
                end
            end

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
