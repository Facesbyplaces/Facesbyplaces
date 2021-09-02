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
        post = Posts::Create.new(post: post_params, user: @user, tagpeople: params[:tag_people]).execute

        if post 
            render json: { post: PostSerializer.new( Post.last ).attributes, status: :created }
        else
            render json: { error: post }, status: 400
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

end