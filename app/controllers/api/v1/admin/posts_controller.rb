class Api::V1::Admin::PostsController < ApplicationController
    before_action :check_user
    before_action :admin_only

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
        if params[:account_type].to_i === 1
            @user = User.find(params[:user_id])
        elsif params[:account_type].to_i === 2
            @user = AlmUser.find(params[:user_id])
        end

        post.account = user

        if post.save
            # check if there are people that have been tagged
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

            puts people
                
            # Add to notification
                # For blm followers
                (post.page.users.uniq).each do |user|
                    # check if this user can get notification
                    if user.notifsetting.newActivities == true
                        # check if the user is in the tag people
                        if people.include?([user.id, user.account_type])
                            Notification.create(recipient: user, actor: @user, action: "#{@user.first_name} tagged you in a post in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{@user.first_name} tagged you in a post in #{post.page.name} #{post.page_type}"
                            PushNotification(device_token, title, message, user, @user, post.id, "Post", post.page_type)
                        else
                            Notification.create(recipient: user, actor: @user, action: "#{@user.first_name} posted in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{@user.first_name} posted in #{post.page.name} #{post.page_type}"
                            PushNotification(device_token, title, message, user, @user, post.id, "Post", post.page_type)
                        end
                    end
                end

                # For alm followers
                (post.page.alm_users.uniq).each do |user|
                    # check if this user can get notification
                    if user.notifsetting.newActivities == true
                        # check if the user is in the tag people
                        if people.include?([user.id, user.account_type])
                            Notification.create(recipient: user, actor: @user, action: "#{@user.first_name} tagged you in a post in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{@user.first_name} tagged you in a post in #{post.page.name} #{post.page_type}"
                            PushNotification(device_token, title, message, user, @user, post.id, "Post", post.page_type)
                        else
                            Notification.create(recipient: user, actor: @user, action: "#{@user.first_name} posted in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{@user.first_name} posted in #{post.page.name} #{post.page_type}"
                            PushNotification(device_token, title, message, user, @user, post.id, "Post", post.page_type)
                        end
                    end
                end

                # For families and friends
                (post.page.relationships).each do |relationship|
                    if relationship.account != @user && relationship.account.notifsetting.newActivities == true
                        if people.include?([relationship.account.id, relationship.account.account_type])
                            Notification.create(recipient: relationship.account, actor: @user, action: "#{@user.first_name} tagged you in a post in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = relationship.account.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{@user.first_name} tagged you in a post in #{post.page.name} #{post.page_type}"
                            PushNotification(device_token, title, message, user, @user, post.id, "Post", post.page_type)
                        else
                            Notification.create(recipient: relationship.account, actor: user, action: "#{@user.first_name} posted in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = relationship.account.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{@user.first_name} posted in #{post.page.name} #{post.page_type}"
                            PushNotification(device_token, title, message, user, @user, post.id, "Post", post.page_type)
                        end
                    end
                end

            render json: {post: PostSerializer.new( post ).attributes, status: :created}
        else
            render json: {errors: post.errors}, status: 500
        end
    end
    
    # Index Posts
    def allPosts  
        posts = Post.all

        render json: {  itemsremaining:  itemsRemaining(posts),
                        posts: ActiveModel::SerializableResource.new(
                                posts, 
                                each_serializer: PostSerializer
                            )
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
        post = get_post

        render json: PostSerializer.new( post ).attributes
    end

    def editPost
        post = get_post
        
        # check if data sent is empty or not
        check = params_presence(params)
        if check == true
            # Update memorial details
            post.update(post_params)

            return render json: {post: PostSerializer.new( post ).attributes, status: "Post Updated"}
        else
            return render json: {error: "#{check} is empty"}
        end
    end

    def editImageOrVideosPost
        post = get_post
        
        # check if data sent is empty or not
        check = params_presence(params)
        if check == true
            # Update memorial details
            post.update(post_image_params)

            return render json: {post: PostSerializer.new( post ).attributes, status: "Post Images or Videos Updated"}
        else
            return render json: {error: "#{check} is empty"}
        end
    end

    def deletePost
        post = get_post
        post.destroy 

        render json: {status: :deleted}
    end

    private

    def post_params
        params.require(:post).permit(:page_type, :page_id, :body, :location, :longitude, :latitude)
    end

    def post_image_params
        params.permit(imagesOrVideos: [])
    end

    def get_post
        post = Post.find(params[:id])
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
        if !user.has_role? :admin 
            return render json: {status: "Must be an admin to continue"}, status: 401
        end
    end

end