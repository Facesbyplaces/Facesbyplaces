class Api::V1::Posts::PostsController < ApplicationController
    include Postable
    before_action :authenticate_user, except: [:index, :show, :pagePosts]
    before_action :set_page, only: [:create]
    before_action :set_post, only: [:show, :delete, :setPostDeletable]    
    before_action :verify_page_admin, only: [:create, :delete, :setPostDeletable]
    before_action :verify_page_owner, only: [:delete, :setPostDeletable]
    before_action :set_posts, only: [:index]
    before_action :set_page_posts, only: [:pagePosts]
    before_action :set_pages, only: [:listOfPages]

    def index  
        render json: {  itemsremaining:  itemsRemaining(@posts),
                        posts: ActiveModel::SerializableResource.new(
                                @posts, 
                                each_serializer: PostSerializer
                            )
                    }
    end

    def create
        post = Posts::Create.new(post: post_params, user: user(), tagpeople: params[:tag_people]).execute

        if post 
            render json: { post: PostSerializer.new( Post.last ).attributes, status: :created }
        else
            render json: { error: post }, status: 400
        end    
    end

    def show
        render json: {post: PostSerializer.new( @post ).attributes}
    end

    def setPostDeletable
        @post.update(deletable: params[:deletable])
        render json: { success: "Post is now deletable." }, status: 200
    end

    def delete
        if @post.deletable
            delete_post_replies(@post)
            delete_post_comments(@post)

            @post.destroy
            render json: { status: :deleted }
        else 
            render json: { error: "Post is not deletable." }, status: 400
        end
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
            like = Posts::Like.new( user: user(), post: params[:post_id] ).execute

            if like 
                render json: { status: "Liked Post" }, status: 200 
            else 
                render json: { errors: like }, status: 404
            end
        else
            unlike = Posts::Unlike.new( user: user(), post: params[:post_id] ).execute

            if unlike 
                render json: {status: "Unliked Post"}, status: 200 
            else 
                render json: { errors: unlike }, status: 404
            end
        end
    end

    def listOfPages
        render json: { pages: @pages }
    end

    private

    def post_params
        params.require(:post).permit(:page_type, :page_id, :body, :location, :longitude, :latitude, imagesOrVideos: [])
    end

    def delete_post_comments(post)
        post.comments.map{ |comment| 
            comment.destroy
        }
    end

    def delete_post_replies(post)
        post.comments.map { |comment|
            comment.replies.map{ |reply| reply.destroy }
        }
    end

    def verify_page_admin
        unless user().has_role? :pageadmin, @page || @post.page
            return render json: {error: "Access Denied. You are not a pageadmin of this Memorial."}, status: 401
        end
    end

    def verify_page_owner
        unless user().pageowners.where(page_id: @post.page.id).first
            return render json: {error: "Access Denied. You are not a pageadmin of this Memorial."}, status: 401
        end
    end

end
