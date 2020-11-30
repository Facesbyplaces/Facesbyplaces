class Api::V1::Posts::PostsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show, :pagePosts]
    before_action :set_up, only: [:create]

    def index  
        posts = Post.where(:user_id => current_user.id)
        
        paginate posts, per_page: numberOfPage
    end

    def create
        post = Post.new(post_params)
        post.user = user()

        if post.save
            # check if there are people that have been tagged
            if params[:tag_people]
                people = params[:tag_people]
                # save tagged people to database
                people.each do |person|
                    tag = Tagperson.new(post_id: post.id, user_id: person)
                    if !tag.save
                        return render json: {errors: tag.errors}, status: 500
                    end
                end
                
                # Add to notification
                    # For followers
                    (post.page.users.uniq - [user()]).each do |user|
                        # check if the user is in the tag people
                        if people.include?("#{user.id}")
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}", url: "posts/#{post.id}", read: false)
                        else
                            Notification.create(recipient: user, actor: user(), action: "#{user().first_name} posted in #{post.page.name} #{post.page_type}", url: "posts/#{post.id}", read: false)
                        end
                    end

                    # For families and friends
                    (post.page.relationships).each do |relationship|
                        if !relationship.user == user()
                            if people.include?("#{user.id}")
                                Notification.create(recipient: relationship.user, actor: user(), action: "#{user().first_name} tagged you in a post in #{post.page.name} #{post.page_type}", url: "posts/#{post.id}", read: false)
                            else
                                Notification.create(recipient: relationship.user, actor: user(), action: "#{user().first_name} posted in #{post.page.name} #{post.page_type}", url: "posts/#{post.id}", read: false)
                            end
                        end
                    end
            else
                # Add to notification
                    # For followers
                    (post.page.users.uniq - [user()]).each do |user|
                        Notification.create(recipient: user, actor: user(), action: "#{user().first_name} posted in #{post.page.name} #{post.page_type}", url: "posts/#{post.id}", read: false)
                    end

                    # For families and friends
                    (post.page.relationships).each do |relationship|
                        if !relationship.user == user()
                            if relationship.user.notifsettings.where(ignore_type: "Post", ignore_id: post.id).count == 0
                                Notification.create(recipient: relationship.user, actor: user(), action: "#{user().first_name} posted in #{post.page.name} #{post.page_type}", url: "posts/#{post.id}", read: false)
                            end
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

        paginate posts, per_page: numberOfPage
    end

    def like
        if Postslike.where(user: user(), post_id: params[:post_id]).first == nil
            like = Postslike.new(post_id: params[:post_id], user_id: user().id)
            if like.save 
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
end
