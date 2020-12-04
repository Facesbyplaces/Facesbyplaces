class Api::V1::Pageadmin::PageadminController < ApplicationController
    before_action :authenticate_user!
    before_action :set_up

    def addAdmin
        # check if user is already a page admin
        if User.with_role(:pageadmin, @page).where(id: @user.id).first == nil
            case params[:page_type]
            when "Blm"
                if @user.account_type == 1
                    # Check if the user if part of the family or friends
                    if @page.relationships.where(user: @user).first
                        # Add page admin rights to the user
                        @user.add_role "pageadmin", @page

                        render json: {}, status: 200
                    else
                        render json: {}, status: 406
                    end
                else
                    render json: {}, status: 401
                end
            when "Memorial"
                if @user.account_type == 2
                    # Check if the user if part of the family or friends
                    if @page.relationships.where(user: @user).first
                        # Add page admin rights to the user
                        @user.add_role "pageadmin", @page

                        render json: {}, status: 200
                    else
                        render json: {}, status: 406
                    end
                else
                    render json: {}, status: 401
                end
            end
        else
            render json: {}, status: 409
        end
    end
    
    def removeAdmin
        if User.with_role(:pageadmin, @page).where(id: @user.id).first != nil
            # Remove page admin rights to the user
            @user.remove_role "pageadmin", @page

            render json: {status: "Removed Admin"}
        else
            render json: {}, status: 404
        end
    end

    def addFamily
        # check if relationship already exists
        if @page.relationships.where(user: @user).first == nil && Follower.where(user: @user, page_type: params[:page_type], page_id: params[:page_id]).first == nil
            # add new relationship to the page
            family = @page.relationships.new(relationship: params[:relationship], user: @user)
            # save relationship
            if family.save 
                render json: {status: "Added Successfuly", relationship_id: family.id}
            else
                render json: {status: family.errors}
            end
        else 
            render json: {}, status: 409
        end
    end

    def addFriend
        # check if relationship already exists
        if @page.relationships.where(user: @user).first == nil && Follower.where(user: @user, page_type: params[:page_type], page_id: params[:page_id]).first == nil
            # add new relationship to the page
            friend = @page.relationships.new(relationship: params[:relationship], user: @user)
            # save relationship
            if friend.save 
                render json: {status: "Added Successfuly", relationship_id: friend.id}
            else
                render json: {status: friend.errors}
            end
        else
            render json: {}, status: 409
        end
    end

    def removeFamilyorFriend
        # check if relation exist or not
        if @page.relationships.where(user: @user).first != nil
            if @page.relationships.where(user: @user).first.destroy 
                render json: {status: "Deleted Successfully"}
            else
                render json: {}, status: 500
            end
        else
            render json: {}, status: 404
        end
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

    def unhideOrHideFamily
        case params[:page_type]
        when 'Blm'
            page = Blm.find(params[:page_id])
        when 'Memorial'
            page = Memorial.find(params[:page_id])
        end

        if page.hideFamily 
            page.update(hideFamily: false)
        else
            page.update(hideFamily: true)
        end

        render json: {}, status: 200
    end

    def unhideOrHideFriends
        case params[:page_type]
        when 'Blm'
            page = Blm.find(params[:page_id])
        when 'Memorial'
            page = Memorial.find(params[:page_id])
        end

        if page.hideFriends 
            page.update(hideFriends: false)
        else
            page.update(hideFriends: true)
        end

        render json: {}, status: 200
    end

    def unhideOrHideFollowers
        case params[:page_type]
        when 'Blm'
            page = Blm.find(params[:page_id])
        when 'Memorial'
            page = Memorial.find(params[:page_id])
        end

        if page.hideFollowers
            page.update(hideFollowers: false)
        else
            page.update(hideFollowers: true)
        end

        render json: {}, status: 200
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
            return render json: {status: "Access Denied"}, status: 401
        end
    end

    def post_params
        params.permit(:page_type, :page_id, :body, :location, :longitude, :latitude, imagesOrVideos: [])
    end
end
