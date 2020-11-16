class Api::V1::Posts::PostsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show, :pagePosts]

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
                    tag.save
                end
            end

            # Add to notification
            (post.page.users.uniq - [user()]).each do |user|
                Notification.create(recipient: user, actor: user(), action: "New post in #{post.page.name}", url: "posts/#{post.id}", read: false)
            end

            render json: {post: PostSerializer.new( post ).attributes, status: :created}
        else
            render json: {errors: post.errors}
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
        like = Postslike.new(post_id: params[:post_id], user_id: user().id)
        like.save 
        render json: {status: "Liked Post"}
    end

    def unlike
        unlike = Postslike.where("post_id = #{params[:post_id]} AND user_id = #{user().id}").first
        unlike.destroy 
        render json: {status: "Unliked Post"}
    end

    private

    def post_params
        params.require(:post).permit(:page_type, :page_id, :body, :location, :longitude, :latitude, imagesOrVideos: [])
    end
end
