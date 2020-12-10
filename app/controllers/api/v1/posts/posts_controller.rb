class Api::V1::Posts::PostsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show, :pagePosts]
    before_action :set_up, only: [:create]

    def index  
        posts = Post.where(:user_id => current_user.id)

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
        post.user = user()

        if post.save
            # check if there are people that have been tagged
            params[:tag_people][0] != "" ? people = params[:tag_people] : people = []
            if people.count != 0
                # save tagged people to database
                people.each do |person|
                    tag = Tagperson.new(post_id: post.id, user_id: person)
                    if !tag.save
                        return render json: {errors: tag.errors}, status: 500
                    end
                end
            end
                
            # Add to notification
                # For followers
                (post.page.users.uniq - [user()]).each do |user|
                    # check if this user can get notification
                    if user.notifsetting.newActivities == true
                        # check if the user is in the tag people
                        if people.include?("#{user.id}")
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}", postId: post.id, read: false)
                        else
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} posted in #{post.page.name} #{post.page_type}", postId: post.id, read: false)
                        end
                    end
                end

                # For families and friends
                (post.page.relationships).each do |relationship|
                    if relationship.user != user() && relationship.user.notifsetting.newActivities == true
                        if people.include?("#{relationship.user.id}")
                            Notification.create(recipient: relationship.user, actor: user(), action: "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}", postId: post.id, read: false)
                        else
                            Notification.create(recipient: relationship.user, actor: user(), action: "#{user().first_name} posted in #{post.page.name} #{post.page_type}", postId: post.id, read: false)
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

    def likeStatus
        numberOfLikes = Postslike.where(post_id: params[:post_id]).count 

        if Post.find(params[:post_id])
            if Postslike.where(user: user(), post_id: params[:post_id]).first
                render json: {
                    like: true,
                    numberOfLikes: numberOfLikes
                }, status: 200
            else
                render json: {
                    like: false,
                    numberOfLikes: numberOfLikes
                }, status: 200
            end
        else
            render json: {}, status: 404
        end
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
        pagesId = user().roles.joins("INNER JOIN blms ON roles.resource_id = blms.id").select('blms.id')

        pages = pagesId.collect do |page|
            page = Blm.find(page.id)
            ActiveModel::SerializableResource.new(
                page, 
                each_serializer: BlmSerializer
            )
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
        if Postslike.where(user: user(), post_id: params[:post_id]).first == nil
            like = Postslike.new(post_id: params[:post_id], user_id: user().id)
            if like.save 
                # Add to notification
                    post = Post.find(params[:post_id])
                    people = post.users
                    # For followers
                    (post.page.users.uniq - [user()]).each do |user|
                        # check if the user can get notification from this api
                        if user.notifsetting.postLikes == true
                            # check if the user is in the tag people
                            if people.include?("#{user.id}")
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} liked a post that you're tagged in", postId: post.id, read: false)
                            else
                                Notification.create(recipient: user, actor: user(), action: "#{user().first_name} liked a post in #{post.page.name} #{post.page_type}", postId: post.id, read: false)
                            end
                        end
                    end

                    # For families and friends
                    (post.page.relationships).each do |relationship|
                        if relationship.user != user() && relationship.user.notifsetting.postLikes == true
                            if people.include?("#{relationship.user.id}")
                                Notification.create(recipient: relationship.user, actor: user(), action: "#{user().first_name} liked a post that you're tagged in", postId: post.id, read: false)
                            elsif relationship.user == post.user 
                                Notification.create(recipient: relationship.user, actor: user(), action: "#{user().first_name} liked your post", postId: post.id, read: false)
                            else
                                Notification.create(recipient: relationship.user, actor: user(), action: "#{user().first_name} liked a post in #{post.page.name} #{post.page_type}", postId: post.id, read: false)
                            end
                        end
                    end

                render json: {}, status: 200
            else
                render json: {errors: like.errors}, status: 500
            end
        else
            render json: {}, status: 409
        end
    end

    def unlike
        if Postslike.where(user: user(), post_id: params[:post_id]).first != nil
            unlike = Postslike.where("post_id = #{params[:post_id]} AND user_id = #{user().id}").first
            if unlike.destroy 
                render json: {status: "Unliked Post"}
            else
                render json: {errors: unlike.errors}, status: 500
            end
        else
            render json: {}, status: 404
        end
    end
end
