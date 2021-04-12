class Api::V1::Posts::PostsController < ApplicationController
    before_action :check_user, except: [:index, :show, :pagePosts]
    before_action :set_up, only: [:create]

    def index  
        posts = Post.where(account: user())

        posts = posts.page(params[:page]).per(numberOfPage)
        if posts.total_count == 0 || (posts.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif posts.total_count < numberOfPage
            itemsremaining = posts.total_count 
        else
            itemsremaining = posts.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        posts: ActiveModel::SerializableResource.new(
                                posts, 
                                each_serializer: PostSerializer
                            )
                    }
    end

    def create
        post = Post.new(post_params)
        post.account = user()

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
                (post.page.users.uniq - user_in_page(1)).each do |user|
                    # check if this user can get notification
                    if user.notifsetting.newActivities == true
                        # check if the user is in the tag people
                        if people.include?([user.id, user.account_type])
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}"
                            PushNotification(device_token, title, message)
                        else
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} posted in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{user().first_name} posted in #{post.page.name} #{post.page_type}"
                            PushNotification(device_token, title, message)
                        end
                    end
                end

                # For alm followers
                (post.page.alm_users.uniq - user_in_page(2)).each do |user|
                    # check if this user can get notification
                    if user.notifsetting.newActivities == true
                        # check if the user is in the tag people
                        if people.include?([user.id, user.account_type])
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}"
                            PushNotification(device_token, title, message)
                        else
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} posted in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = user.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{user().first_name} posted in #{post.page.name} #{post.page_type}"
                            PushNotification(device_token, title, message)
                        end
                    end
                end

                # For families and friends
                (post.page.relationships).each do |relationship|
                    if relationship.account != user() && relationship.account.notifsetting.newActivities == true
                        if people.include?([relationship.account.id, relationship.account.account_type])
                            Notification.create(recipient: relationship.account, actor: user(), action: "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = relationship.account.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}"
                            PushNotification(device_token, title, message)
                        else
                            Notification.create(recipient: relationship.account, actor: user(), action: "#{user().first_name} posted in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                            #Push Notification
                            device_token = relationship.account.device_token
                            title = "FacesbyPlaces Notification"
                            message = "#{user().first_name} posted in #{post.page.name} #{post.page_type}"
                            PushNotification(device_token, title, message)
                        end
                    end
                end

            render json: {post: PostSerializer.new( post ).attributes, status: :created}
        else
            render json: {errors: post.errors}, status: 500
        end
    end

    def show
        post = Post.find(params[:id])

        render json: {post: PostSerializer.new( post ).attributes}
    end

    def pagePosts
        posts = Post.where(page_type: params[:page_type], page_id: params[:page_id]).order(created_at: :desc)

        posts = posts.page(params[:page]).per(numberOfPage)
        if posts.total_count == 0 || (posts.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif posts.total_count < numberOfPage
            itemsremaining = posts.total_count 
        else
            itemsremaining = posts.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        posts: ActiveModel::SerializableResource.new(
                            posts, 
                            each_serializer: PostSerializer
                        )
                    }
    end

    def unlikeOrLike
        if params[:like].downcase == 'true'
            like()
        else
            unlike()
        end
    end

    # pages that the user can manage
    def listOfPages
        if user().account_type == 1
            pagesId = user().roles.select('id')

            pages = pagesId.collect do |page|
                page = Blm.find(page.id).present? ? Blm.find(page.id) : Blm.find(page.id - 1)
                ActiveModel::SerializableResource.new(
                    page, 
                    each_serializer: BlmSerializer
                )
            end
        else
            pagesId = user().roles.select('id')

            pages = pagesId.collect do |page|
                page = Memorial.find(page.id)
                ActiveModel::SerializableResource.new(
                    page, 
                    each_serializer: MemorialSerializer
                )
            end
        end

        render json: { pages: pages }
    end

    private
    def post_params
        params.require(:post).permit(:page_type, :page_id, :body, :location, :longitude, :latitude, imagesOrVideos: [])
    end

    def set_up
        # find page
        case params[:post][:page_type]
        when "Blm"
            page = Blm.find(params[:post][:page_id])
        when "Memorial"
            page = Memorial.find(params[:post][:page_id])
        end

        if !user().has_role? :pageadmin, page 
            return render json: {}, status: 401
        end
    end

    def like
        if Postslike.where(account: user(), post_id: params[:post_id]).first == nil
            like = Postslike.new(post_id: params[:post_id], account: user())
            if like.save 
                # Add to notification
                    post = Post.find(params[:post_id])
                    people_blm_users = post.users
                    people_alm_users = post.alm_users
                    # For blm followers
                    (post.page.users.uniq - user_in_page(1)).each do |user|
                        # check if the user can get notification from this api
                        if user.notifsetting.postLikes == true
                            # check if the user is in the tag people
                            if people_blm_users.include?(user) || people_alm_users.include?(user)
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} liked a post that you're tagged in", postId: post.id, read: false, notif_type: 'Post')
                            else
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} liked a post in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                            end
                        end
                    end
                    # For alm followers
                    (post.page.alm_users.uniq - user_in_page(2)).each do |user|
                        # check if the user can get notification from this api
                        if user.notifsetting.postLikes == true
                            # check if the user is in the tag people
                            if people_blm_users.include?(user) || people_alm_users.include?(user)
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} liked a post that you're tagged in", postId: post.id, read: false, notif_type: 'Post')
                            else
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} liked a post in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                            end
                        end
                    end

                    # For families and friends
                    (post.page.relationships).each do |relationship|
                        if relationship.account != user() && relationship.account.notifsetting.postLikes == true
                            if people_blm_users.include?(relationship.account) || people_alm_users.include?(relationship.account)
                                Notification.create(recipient: relationship.account, actor: user(), action: "#{user().first_name} liked a post that you're tagged in", postId: post.id, read: false, notif_type: 'Post')
                                #Push Notification
                                device_token = relationship.account.device_token
                                title = "FacesbyPlaces Notification"
                                message = "#{user().first_name} liked a post that you're tagged in"
                                PushNotification(device_token, title, message)
                            elsif relationship.account == post.account 
                                Notification.create(recipient: relationship.account, actor: user(), action: "#{user().first_name} liked your post", postId: post.id, read: false, notif_type: 'Post')
                                #Push Notification
                                device_token = relationship.account.device_token
                                title = "FacesbyPlaces Notification"
                                message = "#{user().first_name} liked your post"
                                PushNotification(device_token, title, message)
                            else
                                Notification.create(recipient: relationship.account, actor: user(), action: "#{user().first_name} liked a post in #{post.page.name} #{post.page_type}", postId: post.id, read: false, notif_type: 'Post')
                                #Push Notification
                                device_token = relationship.account.device_token
                                title = "FacesbyPlaces Notification"
                                message = "#{user().first_name} liked a post in #{post.page.name} #{post.page_type}"
                                PushNotification(device_token, title, message)
                            end
                        end
                    end

                render json: { user: user }, status: 200
            else
                render json: {errors: like.errors}, status: 500
            end
        else
            render json: {error: 'Account required.'}, status: 409
        end
    end

    def user_in_page(account_type)
        if user().account_type == account_type
            return [user()]
        else
            return []
        end
    end

    def unlike
        if Postslike.where(account: user(), post_id: params[:post_id]).first != nil
            unlike = Postslike.where(account: user(), post_id: params[:post_id]).first
            if unlike.destroy 
                render json: {status: "Unliked Post"}
            else
                render json: {errors: unlike.errors}, status: 500
            end
        else
            render json: {error: "Account required."}, status: 404
        end
    end

    def PushNotification(device_tokens, title, message)
        require 'fcm'
        puts        "\n-- Device Token : --\n#{device_tokens}"
        logger.info "\n-- Device Token : --\n#{device_tokens}"

        fcm_client = FCM.new(Rails.application.credentials.dig(:firebase, :server_key))
        options = { notification: { 
                        body: 'message',
                        title: 'title',
                    }
                }

        begin
            response = fcm_client.send(device_tokens, options)
        rescue StandardError => err
            puts        "\n-- PushNotification : Error --\n#{err}"
            logger.info "\n-- PushNotification : Error --\n#{err}"
        end

        puts response
    end
end
