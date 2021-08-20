class Posts::Create

    def initialize( post:, user:, tagpeople: )
        @post                   = post
        @user                   = user
        @tagpeople              = tagpeople
    end

    def execute
        post = Post.new(@post)
        post.account = @user

        if post.save
            # Add to notification
            notify_followers_of_a_post(post)
            return true
        else
            return post.errors
        end
    end

    private

    def notify_followers_of_a_post(post)
        # Add tagged people
        people = tag_people(post)
        
        # For blm followers
        (post.page.users.uniq - user_in_page(1)).each do |user|
            # check if this user can get notification
            if user.notifsetting.newActivities == true
                # check if the user is in the tag people
                if people.include?([user.id, user.account_type])
                    Notification::Builder.new(
                        device_tokens:  user.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} tagged you in a post in #{post.page.name} #{post.page_type}",
                        recipient:      user,
                        actor:          @user,
                        data:           post.id,
                        type:           "Post",
                        postType:       post.page_type,
                    ).notify
                else
                    message = "#{@user.first_name} posted in #{post.page.name} #{post.page_type}"
                    Notification::Builder.new(
                        device_tokens:  user.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} posted in #{post.page.name} #{post.page_type}",
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
            # check if this user can get notification
            if user.notifsetting.newActivities == true
                # check if the user is in the tag people
                if people.include?([user.id, user.account_type])
                    Notification::Builder.new(
                        device_tokens:  user.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} tagged you in a post in #{post.page.name} #{post.page_type}",
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
                        message:        "#{@user.first_name} posted in #{post.page.name} #{post.page_type}",
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
            if relationship.account != @user && relationship.account.notifsetting.newActivities == true
                if people.include?([relationship.account.id, relationship.account.account_type])
                    Notification::Builder.new(
                        device_tokens:  relationship.account.device_token,
                        title:          "FacesByPlaces Notification",
                        message:        "#{@user.first_name} tagged you in a post in #{post.page.name} #{post.page_type}",
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
                        message:        "#{@user.first_name} posted in #{post.page.name} #{post.page_type}",
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
                    message:        "#{@user.first_name} tagged you in a post in #{post.page.name} #{post.page_type}",
                    recipient:      user.account,
                    actor:          @user,
                    data:           post.id,
                    type:           "Post",
                    postType:       post.page_type,
            ).notify  
        end
    end

    def tag_people(post)
        people_tags = @tagpeople || []
        people = []

        people_tags.each do |key, value|
            user_id = value[:user_id].to_i
            account_type = value[:account_type].to_i 

            if account_type == 1
                user = User.find(user_id)
                tag = Tagperson.new(post_id: post.id, account: user)
                return render json: {errors: tag.errors}, status: 500 unless tag.save
            else
                user = AlmUser.find(user_id)
                tag = Tagperson.new(post_id: post.id, account: user)
                return render json: {errors: tag.errors}, status: 500 unless tag.save
            end

            people.push([user_id, account_type])
        end

        return people
    end

    def user_in_page(account_type)
        if @user.account_type == account_type
            return [@user]
        else
            return []
        end
    end

    
end