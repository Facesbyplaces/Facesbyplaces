class Api::V1::Admin::PostsController < ApplicationController
    include Postable
    before_action :verify_admin
    before_action :set_memorials, only: [:memorialSelection]
    before_action :set_pageadmins, only: [:pageAdmins]
    before_action :set_posts, only: [:allPosts]
    before_action :set_alm_posts, only: [:allPosts]
    before_action :set_blm_posts, only: [:allPosts]
    before_action :set_searched_posts, only: [:searchPost]
    before_action :set_post, only: [:showPost, :editPost, :editImageOrVideosPost, :deletePost]
    before_action :set_user, only: [:createPost]

    # Memorial lists to associate post
    def pageAdmins #for create memorial users selection
        render json: {success: true,  pageadmins: @pageadmins }, status: 200
    end

    # Memorial lists to associate post
    def memorialSelection #for create post memorials selection
        render json: {success: true,  memorials: @memorials }, status: 200
    end

    def createPost
        post = Post.new(post_params)
        post.account = user

        if post.save
            notify_users_of_a_post(post)

            render json: {post: PostSerializer.new( post ).attributes, status: :created}
        else
            render json: {errors: post.errors}, status: 500
        end
    end
    
    def allPosts  
        render json: {  itemsremaining:  itemsRemaining(@posts),
                        alm: ActiveModel::SerializableResource.new(
                                @alm_posts, 
                                each_serializer: PostSerializer
                            ),
                        blm: ActiveModel::SerializableResource.new(
                            @blm_posts, 
                            each_serializer: PostSerializer
                        ),
                    }
    end

    def searchPost
        render json: {  itemsremaining:  itemsRemaining(@posts),
                        posts: ActiveModel::SerializableResource.new(
                            @posts, 
                            each_serializer: PostSerializer
                        )
                    }
    end

    def showPost
        render json: PostSerializer.new( @post ).attributes
    end

    def editPost
        return render json: {error: "Params is empty"} unless params_presence(post_params)
        @post.update(post_params)
        render json: {post: PostSerializer.new( @post ).attributes, status: "Post Updated"}
    end

    def editImageOrVideosPost
        return render json: {error: "#{check} is empty"} unless params_presence(params)
        # Update memorial details
        @post.update(post_image_params)
        return render json: {post: PostSerializer.new( @post ).attributes, status: "Post Images or Videos Updated"}
    end

    def deletePost
        @post.destroy 
        render json: {status: :deleted}
    end

    private
    def verify_admin
        unless user().has_role? :admin  
            return render json: {status: "Must be an admin to continue"}, status: 401
        end
    end

    def post_params
        params.require(:post).permit(:page_type, :page_id, :body, :location, :longitude, :latitude)
    end

    def post_image_params
        params.permit(imagesOrVideos: [])
    end

    def tag_people
        people_tags = params[:tag_people] || []
        people = []

        people_tags.each do |key, value|
            user_id = value[:user_id].to_i
            account_type = value[:account_type].to_i 

            if account_type == 1
                user = User.find(user_id)
                tag = Tagperson.new(post_id: post.id, account: user)
                if !tag.save
                    return render json: {errors: tag.errors}, status: 500
                end
            else
                user = AlmUser.find(user_id)
                tag = Tagperson.new(post_id: post.id, account: user)
                if !tag.save
                    return render json: {errors: tag.errors}, status: 500
                end
            end

            people.push([user_id,account_type])
        end

        return people
    end

    def notify_users_of_a_post(post)
        people = tag_people
            
        # Add to notification
            # For blm followers
            (post.page.users.uniq).each do |user|
                # check if this user can get notification
                if user.notifsetting.newActivities == true
                    # check if the user is in the tag people
                    if people.include?([user.id, user.account_type])
                        message = "#{@user.first_name} tagged you in a post in #{post.page.name} #{post.page_type}"
                        send_notif(user, message, post)
                    else
                        message = "#{@user.first_name} posted in #{post.page.name} #{post.page_type}"
                        send_notif(user, message, post)                        
                    end
                end
            end

            # For alm followers
            (post.page.alm_users.uniq).each do |user|
                # check if this user can get notification
                if user.notifsetting.newActivities == true
                    # check if the user is in the tag people
                    if people.include?([user.id, user.account_type])
                        message = "#{@user.first_name} tagged you in a post in #{post.page.name} #{post.page_type}"
                        send_notif(user, message, post)  
                    else
                        message = "#{@user.first_name} posted in #{post.page.name} #{post.page_type}"
                        send_notif(user, message, post) 
                    end
                end
            end

            # For families and friends
            (post.page.relationships).each do |relationship|
                if relationship.account != @user && relationship.account.notifsetting.newActivities == true
                    if people.include?([relationship.account.id, relationship.account.account_type])
                        message = "#{@user.first_name} tagged you in a post in #{post.page.name} #{post.page_type}"
                        send_notif(relationship.account, message, post)
                    else
                        message = "#{@user.first_name} posted in #{post.page.name} #{post.page_type}"
                        send_notif(relationship.account, message, post)
                    end
                end
            end
    end

    def send_notif(user, message, post)
        Notification.create(recipient: user, actor: @user, action: message, postId: post.id, read: false, notif_type: "Post")
        
        #Push Notification
        device_token = user.device_token
        title = "FacesbyPlaces Notification"
        PushNotification(device_token, title, message, user, @user, post.id, "Post", post.page_type)
    end

    def itemsRemaining(posts)
        posts = posts.page(params[:page]).per(numberOfPage)
        if posts.total_count == 0 || (posts.total_count - (params[:page].to_i * numberOfPage)) < 0
            return itemsremaining = 0
        elsif posts.total_count < numberOfPage
            return itemsremaining = posts.total_count 
        else
            return itemsremaining = posts.total_count - (params[:page].to_i * numberOfPage)
        end
    end

end