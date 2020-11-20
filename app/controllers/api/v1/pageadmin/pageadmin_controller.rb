class Api::V1::Pageadmin::PageadminController < ApplicationController
    before_action :authenticate_user!
    before_action :set_up

    def addAdmin
        # Add page admin rights to the user
        @user.add_role "pageadmin", @page

        render json: {status: "Added Admin"}
    end
    
    def removeAdmin
        # Remove page admin rights to the user
        @user.remove_role "pageadmin", @page

        render json: {status: "Removed Admin"}
    end

    def addFamily
        # add new relationship to the page
        family = @page.relationships.new(relationship: params[:relationship], user: @user)
        # save relationship
        if family.save 
            render json: {status: "Added Successfuly", relationship_id: family.id}
        else
            render json: {status: family.errors}
        end
    end

    def removeFamily
        family = Relationship.find(params[:id])
        family.destroy 
        render json: {status: "Deleted Successfully"}
    end

    def addFriend
        # add new relationship to the page
        friend = @page.relationships.new(relationship: params[:relationship], user: @user)
        # save relationship
        if friend.save 
            render json: {status: "Added Successfuly", relationship_id: friend.id}
        else
            render json: {status: friend.errors}
        end
    end

    def removeFriend
        friend = Relationship.find(params[:id])
        friend.destroy 
        render json: {status: "Deleted Successfully"}
    end

    def editPost
        post = Post.find(params[:post_id])

        render json: post
    end

    def updatePost
        post = Post.find(params[:post_id])
        post_creator = post.user
        
        if post.update(post_params)
            post.user = post_creator
            render json: {post: PostSerializer.new( post ).attributes, status: :updated}
        else
            render json: {errors: post.errors}
        end
    end

    def deletePost
        post = Post.find(params[:post_id])
        post.destroy 
        render json: {status: :deleted}
    end

    private
    def set_up
        # Page where the admin is added
        page_type = params[:page_type]
        case page_type
        when "Blm"
            @page = Blm.find(params[:page_id])
        when "Memorial"
            @page = Memorial.find(params[:page_id])
        end

        # Find the user 
        if params[:user_id]
            @user = User.find(params[:user_id])
        end

        if !user().has_role? :pageadmin, @page 
            return render json: {status: "Access Denied"}
        end
    end

    def post_params
        params.permit(:page_type, :page_id, :body, :location, :longitude, :latitude, imagesOrVideos: [])
    end
end
