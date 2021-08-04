class Api::V1::Posts::PostsController < ApplicationController
    include Postable
    before_action :authenticate_user, except: [:index, :show, :pagePosts]
    before_action :set_page, only: [:create]
    before_action :verify_page_admin, only: [:create]
    before_action :set_posts, only: [:index]
    before_action :set_page_posts, only: [:pagePosts]
    before_action :set_post, only: [:show]    

    def index  
        render json: {  itemsremaining:  itemsRemaining(@posts),
                        posts: ActiveModel::SerializableResource.new(
                                @posts, 
                                each_serializer: PostSerializer
                            )
                    }
    end

    def create
        @post = Post.new(post_params)
        @post.account = user()

        if @post.save
            # Add to notification
            notify_followers_of_a_post(@post)

            render json: {post: PostSerializer.new( @post ).attributes, status: :created}
        else
            render json: {errors: @post.errors}, status: 500
        end
    end

    def show
        render json: {post: PostSerializer.new( @post ).attributes}
    end

    def pagePosts
        render json: {  itemsremaining:  itemsRemaining(@posts),
                        posts: ActiveModel::SerializableResource.new(
                            @posts, 
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

    def listOfPages
        if user().account_type == 1
            pagesId = user().roles.select('id')

            pages = pagesId.collect do |page|
                page = Blm.find(page.id)

                ActiveModel::SerializableResource.new(
                    page, 
                    each_serializer: MemorialSerializer
                )
    
            rescue ActiveRecord::RecordNotFound                    
                page = Blm.find(page.id - 1)

                ActiveModel::SerializableResource.new(
                    page, 
                    each_serializer: MemorialSerializer
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

    def verify_page_admin
        if user().has_role? :pageadmin, @page == true
            return render json: {error: "Access Denied."}, status: 401
        end
    end
    
    def notif_type
        @notif_type = 'Post'
    end

    def like
        if Postslike.where(account: user(), post_id: params[:post_id]).first == nil
            like = Postslike.new(post_id: params[:post_id], account: user())
            if like.save 
                # Add to notification
                notify_followers_of_a_like

                render json: { status: "Liked Post" }, status: 200
            else
                render json: {errors: like.errors}, status: 500
            end
        else
            render json: {error: 'Account required.'}, status: 409
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

    def user_in_page(account_type)
        if user().account_type == account_type
            return [user()]
        else
            return []
        end
    end

    def itemsRemaining(data)
        if data.total_count == 0 || (data.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif data.total_count < numberOfPage
            itemsremaining = data.total_count 
        else
            itemsremaining = data.total_count - (params[:page].to_i * numberOfPage)
        end
    end

    def notify_followers_of_a_post(post)
        # Add tagged people
        people = tag_people(post)
        
        # For blm followers
        (post.page.users.uniq - user_in_page(1)).each do |user|
            # check if this user can get notification
            if user.notifsetting.newActivities == true
                # check if the user is in the tag people
                if people.include?([user.id, user.account_type])
                    message = "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}"
                    send_notif(user, message, post, notif_type)
                else
                    message = "#{user().first_name} posted in #{post.page.name} #{post.page_type}"
                    send_notif(user, message, post, notif_type)                    
                end
            end
        end

        # For alm followers
        (post.page.alm_users.uniq - user_in_page(2)).each do |user|
            # check if this user can get notification
            if user.notifsetting.newActivities == true
                # check if the user is in the tag people
                if people.include?([user.id, user.account_type])
                    message = "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}"
                    send_notif(user, message, post, notif_type)
                else
                    message = "#{user().first_name} posted in #{post.page.name} #{post.page_type}"
                    send_notif(user, message, post, notif_type)
                end
            end
        end

        # For families and friends
        (post.page.relationships).each do |relationship|
            if relationship.account != user() && relationship.account.notifsetting.newActivities == true
                if people.include?([relationship.account.id, relationship.account.account_type])
                    message = "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}"
                    send_notif(relationship.account, message, post, notif_type)
                else
                    message = "#{user().first_name} posted in #{post.page.name} #{post.page_type}"
                    send_notif(relationship.account, message, post, notif_type)
                end
            end
        end

        # For tagged people
        (post.tagpeople).each do |user|
            next unless post.page.relationships.find_by(account_id: user.account_id) == nil
            next unless post.page.followers.find_by(account_id: user.account_id) == nil
             
            if user.account_type == "AlmUser" 
                message = "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}"
                send_notif(user.account, message, post, notif_type)
            else
                message = "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}"
                send_notif(user.account, message, post, notif_type)
            end
        end
    end

    def notify_followers_of_a_like
        post = Post.find(params[:post_id])
        people_blm_users = post.users
        people_alm_users = post.alm_users
        
        # For blm followers
        (post.page.users.uniq - user_in_page(1)).each do |user|
            # check if the user can get notification from this api
            if user.notifsetting.postLikes == true
                # check if the user is in the tag people
                if people_blm_users.include?(user) || people_alm_users.include?(user)
                    message = "#{user().first_name} liked a post that you're tagged in"
                    send_notif(user, message, post, notif_type)
                else
                    message = "#{user().first_name} liked a post in #{post.page.name} #{post.page_type}"
                    send_notif(user, message, post, notif_type)
                end
            end
        end

        # For alm followers
        (post.page.alm_users.uniq - user_in_page(2)).each do |user|
            # check if the user can get notification from this api
            if user.notifsetting.postLikes == true
                # check if the user is in the tag people
                if people_blm_users.include?(user) || people_alm_users.include?(user)
                    message = "#{user().first_name} liked a post that you're tagged in"
                    send_notif(user, message, post, notif_type)
                else
                    message = "#{user().first_name} liked a post in #{post.page.name} #{post.page_type}"
                    send_notif(user, message, post, notif_type)
                end
            end
        end

        # For families and friends
        (post.page.relationships).each do |relationship|
            if relationship.account != user() && relationship.account.notifsetting.postLikes == true
                if people_blm_users.include?(relationship.account) || people_alm_users.include?(relationship.account)
                    message = "#{user().first_name} liked a post that you're tagged in"
                    send_notif(relationship.account, message, post, notif_type)
                elsif relationship.account == post.account 
                    message = "#{user().first_name} liked your post"
                    send_notif(relationship.account, message, post, notif_type)
                else
                    message = "#{user().first_name} liked a post in #{post.page.name} #{post.page_type}"
                    send_notif(relationship.account, message, post, notif_type)
                end
            end
        end

        # For tagged people
        (post.tagpeople).each do |user|
            next unless post.page.relationships.find_by(account_id: user.account_id) == nil
            next unless post.page.followers.find_by(account_id: user.account_id) == nil

            if user.account_type == "AlmUser" 
                message = "#{user().first_name} liked a post that tagged you in a post in #{post.page.name} #{post.page_type}"
                send_notif(user.account, message, post, notif_type)
            else
                message = "#{user().first_name} liked a post that tagged you in a post in #{post.page.name} #{post.page_type}"
                send_notif(user.account, message, post, notif_type)
            end
        end
    end

    def tag_people(post)
        people_tags = params[:tag_people] || []
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

    def send_notif(recipient, message, action, notif_type)
        Notification.create(recipient: recipient, actor: user(), action: message, postId: action.id, read: false, notif_type: notif_type)
        
        #Push Notification
        device_token = recipient.device_token
        title = "FacesbyPlaces Notification"
        PushNotification(device_token, title, message, recipient, user(), action.id, notif_type, action.page_type)
    end

end
