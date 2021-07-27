class Api::V1::Admin::PostsController < ApplicationController
    before_action :admin_only
    before_action :set_posts, only: [:allPosts]
    before_action :set_post, only: [:showPost, :editPost, :editImageOrVideosPost, :deletePost]
    before_action :set_user, only: [:createPost]

    # Post
    # Memorial lists to associate post
    def memorialSelection #for create post memorials selection
        memorials = []
        if params[:account_type].to_i == 1
            User.find(params[:user_id]).roles.map{ |role|
            memorials << role.resource
            }
        elsif params[:account_type].to_i === 2
            AlmUser.find(params[:user_id]).roles.map{ |role|
            memorials << role.resource
            }
        end

        render json: {success: true,  memorials: memorials }, status: 200
    end

    # Memorial lists to associate post
    def pageAdmins #for create memorial users selection
        pageadmins = []
        users = User.all.where.not(guest: true, username: "admin")
        alm_users = AlmUser.all
        allUsers = users.order("users.id DESC") + alm_users.order("alm_users.id DESC")

        allUsers.map{ |user| 
            if user.roles.empty?
                puts user
            else
                pageadmins << user
            end
        }

        render json: {success: true,  pageadmins: pageadmins }, status: 200
    end

    # Add Post
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
    
    # Index Posts
    def allPosts  
        @alm_posts = fetched_alm_posts
        @blm_posts = fetched_blm_posts

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
        postsId = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Post').pluck('searchable_id')

        posts = Post.where(id: postsId)
        
        render json: {  itemsremaining:  itemsRemaining(posts),
                        posts: ActiveModel::SerializableResource.new(
                            posts, 
                            each_serializer: PostSerializer
                        )
                    }
    end

    def showPost
        render json: PostSerializer.new( @post ).attributes
    end

    def editPost
        # check if data sent is empty or not
        check = params_presence(params)
        if check == true
            # Update memorial details
            @post.update(post_params)

            return render json: {post: PostSerializer.new( @post ).attributes, status: "Post Updated"}
        else
            return render json: {error: "#{check} is empty"}
        end
    end

    def editImageOrVideosPost
        # check if data sent is empty or not
        check = params_presence(params)
        if check == true
            # Update memorial details
            @post.update(post_image_params)

            return render json: {post: PostSerializer.new( @post ).attributes, status: "Post Images or Videos Updated"}
        else
            return render json: {error: "#{check} is empty"}
        end
    end

    def deletePost
        @post.destroy 

        render json: {status: :deleted}
    end

    private

    def post_params
        params.require(:post).permit(:page_type, :page_id, :body, :location, :longitude, :latitude)
    end

    def post_image_params
        params.permit(imagesOrVideos: [])
    end

    def set_posts
        # page_type = params[:page_type].to_i == 2 ? "Memorial" : "Blm"
        posts = Post.all

        @posts = posts.page(params[:page]).per(numberOfPage)
    end

    def fetched_alm_posts
        alm_posts = @posts.where(page_type: "Memorial")

        return alm_posts = alm_posts.page(params[:page]).per(numberOfPage)
    end

    def fetched_blm_posts
        blm_posts = @posts.where(page_type: "Blm")
        
        return blm_posts = blm_posts.page(params[:page]).per(numberOfPage)
    end

    def set_post
        @post = Post.find(params[:id])
    end

    def set_user
        if params[:account_type].to_i === 1
            @user = User.find(params[:user_id])
        elsif params[:account_type].to_i === 2
            @user = AlmUser.find(params[:user_id])
        end
    end

    def notif_type
        return 'Post'
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

    def send_notif(user, message, post)
        Notification.create(recipient: user, actor: @user, action: message, postId: post.id, read: false, notif_type: notif_type)
        
        #Push Notification
        device_token = user.device_token
        title = "FacesbyPlaces Notification"
        PushNotification(device_token, title, message, user, @user, post.id, notif_type, post.page_type)
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

    def admin_only
        unless user().has_role? :admin  
            return render json: {status: "Must be an admin to continue"}, status: 401
        end
    end

end