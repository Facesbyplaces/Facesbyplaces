class Api::V1::Pageadmin::PageadminController < ApplicationController
    before_action :authenticate_user
    before_action :verify_page_admin
    before_action :fetch_page, except: [:editPost, :updatePost, :deletePost]
    before_action :fetch_user, except: [:editPost, :updatePost, :deletePost, :unhideOrHideFamily, :unhideOrHideFollowers, :unhideOrHideFriends]
    before_action :fetch_post, only: [:editPost, :updatePost, :deletePost]

    def addAdmin
        verify_admin_account_type

        if is_page_admin == false
            case params[:page_type]
            when "Blm"
                if @user.account_type == 1
                    # Check if the user if part of the family or friends
                    if @page.relationships.where(account: @user).first && @user.notifsetting.addAdmin == true
                        # Add page admin rights to the user
                        @user.add_role "pageadmin", @page

                        render json: {}, status: 200
                    else
                        render json: {error: "user is not part of the family or the user does not accept page admin invites"}, status: 406
                    end
                else
                    render json: {}, status: 401
                end
            when "Memorial"
                if @user.account_type == 2
                    # Check if the user if part of the family or friends
                    if @page.relationships.where(account: @user).first && @user.notifsetting.addAdmin == true
                        # Add page admin rights to the user
                        @user.add_role "pageadmin", @page

                        render json: {}, status: 200
                    else
                        render json: {error: "user is not part of the family or the user does not accept page admin invites"}, status: 406
                    end
                else
                    render json: {}, status: 401
                end
            end
        else
            render json: {error: "User is already part of the admin"}, status: 409
        end
    end
    
    def removeAdmin
        is_page_owner

        if is_page_admin == true
            # Remove page admin rights to the user
            @user.remove_role "pageadmin", @page
            render json: {status: "Removed Admin"}
        else
            render json: {error: "User is not part of the admin"}, status: 400
        end
    end

    def addFamily
        add_relationship("family")
    end

    def addFriend
        add_relationship("friend")
    end

    def removeFamilyorFriend
        is_page_owner
        render json: {error: "Cannot remove admin"}, status: 422 unless is_page_admin == false
        
        # check if relation exist or not
        if @page.relationships.where(account: @user).first != nil
            if @page.relationships.where(account: @user).first.destroy 
                render json: {status: "Deleted Successfully"}
            else
                render json: {}, status: 500
            end
        else
            render json: {}, status: 400
        end
    end

    def editPost
        render json: @post
    end

    def updatePost
        post_creator = @post.account
        
        if @post.update(@post_params)
            @post.account = post_creator
            render json: {post: PostSerializer.new( @post ).attributes, status: :updated}
        else
            render json: {errors: @post.errors}
        end
    end

    def deletePost
        @post.destroy 
        render json: {status: :deleted}
    end

    def hideStatus
        render json: {
            family: @page.hideFamily,
            friends: @page.hideFriends,
            followers: @page.hideFollowers
        }
    end

    def unhideOrHideFriends
        hideOrUnhide("friends")
    end

    def unhideOrHideFollowers
        hideOrUnhide("followers")
    end

    def unhideOrHideFamily
        hideOrUnhide("family")
    end

    private
    def post_params
        params.permit(:page_type, :page_id, :body, :location, :longitude, :latitude, imagesOrVideos: [])
    end

    def verify_page_admin
        if user().has_role? :pageadmin, @page 
            return render json: {status: "Access Denied"}, status: 401
        end
    end

    def fetch_page
        case params[:page_type]
        when "Blm"
            @page = Blm.find(params[:page_id])
        when "Memorial"
            @page = Memorial.find(params[:page_id])
        end
    end

    def fetch_user
        if params[:user_id]
            if params[:account_type] == "1"
                @user = User.find(params[:user_id])
            else
                @user = AlmUser.find(params[:user_id])
            end
        end
    end

    def fetch_post
        @post = Post.find(params[:post_id])
    end

    def verify_admin_account_type
        if params[:account_type] == "1" && params[:page_type] == "Memorial"
            return render json: {error: "User is not a Blm User"}, status: 401
        elsif params[:account_type] == "2" && params[:page_type] == "Blm"
            return render json: {error: "User is not a Alm User"}, status: 401
        end
    end

    def is_page_admin
        if params[:account_type] == "1"
            # check if user is already a page admin
            User.with_role(:pageadmin, @page).where(id: @user.id).first == nil ? (return false) : (return true)
        elsif params[:account_type] == "2"
            # check if user is already a page admin
            AlmUser.with_role(:pageadmin, @page).where(id: @user.id).first == nil ? (return false) : (return true)
            # elsif @user.has_role? :pageadmin, @page 
            #     # check if user is already a page admin
            #     return render json: {error: "Cannot remove admin"}, status: 422
        end  
    end

    def is_page_owner
        if @page.pageowner.account == @user
            return render json: {error: "Cannot remove pageowner"}, status: 422
        end
    end

    def has_relationship
        if @page.relationships.where(account: @user).first == nil && Follower.where(account: @user, page_type: params[:page_type], page_id: params[:page_id]).first == nil
            return true
        else
            return render json: {}, status: 409
        end
    end

    def add_relationship(relationship)
        if has_relationship
            case relationship
            when "family"
                if @user.notifsetting.addFamily == true
                    # add new relationship to the page
                    family = @page.relationships.new(relationship: params[:relationship], account: @user)
                    # save relationship
                    if family.save 
                        render json: {status: "Added Successfuly", relationship_id: family.id}
                    else
                        render json: {status: family.errors}
                    end
                else
                    render json: {error: "This user declines all add family invites"}, status: 406
                end
            when "friend"
                if @user.notifsetting.addFriends == true
                    # add new relationship to the page
                    friend = @page.relationships.new(relationship: params[:relationship], account: @user)
                    # save relationship
                    if friend.save 
                        render json: {status: "Added Successfuly", relationship_id: friend.id}
                    else
                        render json: {status: friend.errors}
                    end
                else
                    render json: {error: "This user declines all add friends invites"}, status: 406
                end
            end
        end
    end

    def hideOrUnhide(detail)
        case detail 
        when "friends"
            @page.update(hideFriends: params[:hide])
        when "followers"
            @page.update(hideFollowers: params[:hide])
        when "family"
            @page.update(hideFamily: params[:hide])
        else
            return render json: { message: "Detail unavailable", status: 401 }, status: 401
        end

        render json: {}, status: 200
    end

end