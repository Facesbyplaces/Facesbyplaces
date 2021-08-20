class Posts::Like

    def initialize( user:, post: )
        @user   = user
        @post   = post
    end

    def execute
        if Postslike.where(account: @user, post_id: @post).first == nil
            like = Postslike.new(post_id: @post, account: @user)
            if like.save 
                # Add to notification
                notify_followers_of_a_like

                return true
            else
                return like.errors
            end
        else
            return 'Already liked the post'
        end
    end

    private

    def notify_followers_of_a_like
        post = Post.find(@post)
        people_blm_users = post.users
        people_alm_users = post.alm_users
        
        # For blm followers
        (post.page.users.uniq - user_in_page(1)).each do |user|
            # check if the user can get notification from this api
            if user.notifsetting.postLikes == true
                # check if the user is in the tag people
                if people_blm_users.include?(user) || people_alm_users.include?(user)
                    Notification::Builder.new(
                        device_tokens:  user.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} liked a post that you're tagged in",
                        recipient:      user,
                        actor:          @user,
                        data:           post.id,
                        type:           "Post",
                        postType:       post.page_type,
                    ).notify
                else
                    Notification::Builder.new(
                        device_tokens:  user.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} liked a post in #{post.page.name} #{post.page_type}",
                        recipient:      user,
                        actor:          @user,
                        data:           post.id,
                        type:           "Post",
                        postType:       post.page_type,
                    ).notify
                end
            end
        end

        # For alm followers
        (post.page.alm_users.uniq - user_in_page(2)).each do |user|
            # check if the user can get notification from this api
            if user.notifsetting.postLikes == true
                # check if the user is in the tag people
                if people_blm_users.include?(user) || people_alm_users.include?(user)
                    Notification::Builder.new(
                        device_tokens:  user.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} liked a post that you're tagged in",
                        recipient:      user,
                        actor:          @user,
                        data:           post.id,
                        type:           "Post",
                        postType:       post.page_type,
                    ).notify
                else
                    Notification::Builder.new(
                        device_tokens:  user.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} liked a post in #{post.page.name} #{post.page_type}",
                        recipient:      user,
                        actor:          @user,
                        data:           post.id,
                        type:           "Post",
                        postType:       post.page_type,
                    ).notify
                end
            end
        end

        # For families and friends
        (post.page.relationships).each do |relationship|
            if relationship.account != @user && relationship.account.notifsetting.postLikes == true
                if people_blm_users.include?(relationship.account) || people_alm_users.include?(relationship.account)
                    Notification::Builder.new(
                        device_tokens:  relationship.account.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} liked a post that you're tagged in",
                        recipient:      relationship.account,
                        actor:          @user,
                        data:           post.id,
                        type:           "Post",
                        postType:       post.page_type,
                    ).notify
                elsif relationship.account == post.account 
                    Notification::Builder.new(
                        device_tokens:  relationship.account.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} liked your post",
                        recipient:      relationship.account,
                        actor:          @user,
                        data:           post.id,
                        type:           "Post",
                        postType:       post.page_type,
                    ).notify
                else
                    Notification::Builder.new(
                        device_tokens:  relationship.account.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} liked a post in #{post.page.name} #{post.page_type}",
                        recipient:      relationship.account,
                        actor:          @user,
                        data:           post.id,
                        type:           "Post",
                        postType:       post.page_type,
                    ).notify
                end
            end
        end

        # For tagged people
        (post.tagpeople).each do |user|
            next unless post.page.relationships.find_by(account_id: user.account_id) == nil
            next unless post.page.followers.find_by(account_id: user.account_id) == nil

            Notification::Builder.new(
                    device_tokens:  user.account.device_token,
                    title:          "FacesByPlaces Notification",
                    message:        "#{@user.first_name} liked a post that tagged you in a post in #{post.page.name} #{post.page_type}",
                    recipient:      user.account,
                    actor:          @user,
                    data:           post.id,
                    type:           "Post",
                    postType:       post.page_type,
            ).notify
        end
    end

    def user_in_page(account_type)
        if @user.account_type == account_type
            return [@user]
        else
            return []
        end
    end
    
end