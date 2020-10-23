class PostsController < ApplicationController

    def index  
        posts = Post.where(user_id: user_id())
        
        paginate posts, per_page: numberOfPage
    end

    def create
        post = Post.new(post_params)
        post.user_id = user_id()

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
        params.require(:post).permit(:memorial_id, :body, :location, :longitude, :latitude, imagesOrVideos: [])
    end
end
