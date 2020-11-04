class Api::V1::Posts::PostsController < ApplicationController

    # before_action :authenticate_user!

    def index  
        posts = Post.where(:user_id => current_user.id)
        
        paginate posts, per_page: numberOfPage
    end

    def create
        post = Post.new(post_params)
        post.user = user()

        if post.save
            render json: {post: PostSerializer.new( post ).attributes, status: :created}
        else
            render json: {errors: post.errors}
        end
    end

    def show
        post = Post.find(params[:id])

        render json: {post: PostSerializer.new( post ).attributes}
    end

    private

    def post_params
        params.require(:post).permit(:page_type, :page_id, :body, :location, :longitude, :latitude, imagesOrVideos: [])
    end
end
