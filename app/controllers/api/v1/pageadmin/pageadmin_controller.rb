class Api::V1::Pageadmin::PageadminController < ApplicationController
    set_account_type = 1 ? (before_action :authenticate_user!) : (before_action :authenticate_alm_user!) 
    before_action :set_up

    def addAdmin
        if params[:account_type] == "1"
            # Alm User cant be page admin
            if params[:page_type] == "Memorial"
                return render json: {error: "User are not Blm User"}, status: 401
            end

            # check if user is already a page admin
            if User.with_role(:pageadmin, @page).where(id: @user.id).first == nil
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
                render json: {error: "user is already part of the admin"}, status: 409
            end
        else
            # Blm User cant be page admin
            if params[:page_type] == "Blm"
                return render json: {error: "User are not Alm User"}, status: 401
            end

            # check if user is already a page admin
            if AlmUser.with_role(:pageadmin, @page).where(id: @user.id).first == nil
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
                render json: {error: "user is already part of the admin"}, status: 409
            end
        end
    end
    
    def removeAdmin
        if @page.pageowner.account == @user
            return render json: {error: "cannot remove pageowner"}, status: 422
        end

        if params[:account_type] == "1"
            if User.with_role(:pageadmin, @page).where(id: @user.id).first != nil
                # Remove page admin rights to the user
                @user.remove_role "pageadmin", @page

                render json: {status: "Removed Admin"}
            else
                render json: {}, status: 400
            end
        else
            if AlmUser.with_role(:pageadmin, @page).where(id: @user.id).first != nil
                # Remove page admin rights to the user
                @user.remove_role "pageadmin", @page

                render json: {status: "Removed Admin"}
            else
                render json: {}, status: 400
            end
        end
    end

    def addFamily
        # check if relationship already exists
        if @page.relationships.where(account: @user).first == nil && Follower.where(account: @user, page_type: params[:page_type], page_id: params[:page_id]).first == nil
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
                render json: {error: "this user declines all add family invites"}, status: 406
            end
        else 
            render json: {}, status: 409
        end
    end

    def addFriend
        # check if relationship already exists
        if @page.relationships.where(account: @user).first == nil && Follower.where(account: @user, page_type: params[:page_type], page_id: params[:page_id]).first == nil
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
                render json: {error: "this user declines all add friends invites"}, status: 406
            end
        else
            render json: {}, status: 409
        end
    end

    def removeFamilyorFriend
        if @page.pageowner.account == @user
            return render json: {error: "cannot remove pageowner"}, status: 422
        end

        if @user.has_role? :pageadmin, @page 
            return render json: {error: "cannot remove admin"}, status: 422
        end
        
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
        post = Post.find(params[:post_id])

        render json: post
    end

    def updatePost
        post = Post.find(params[:post_id])
        post_creator = post.account
        
        if post.update(post_params)
            post.account = post_creator
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

    def hideStatus
        render json: {
            family: @page.hideFamily,
            friends: @page.hideFriends,
            followers: @page.hideFollowers
        }
    end

    def unhideOrHideFriends
        if params[:hide].downcase == 'true'
            @page.update(hideFriends: true)
        else
            @page.update(hideFriends: false)
        end

        render json: {}, status: 200
    end

    def unhideOrHideFollowers
        if params[:hide].downcase == 'true'
            @page.update(hideFollowers: true)
        else
            @page.update(hideFollowers: false)
        end

        render json: {}, status: 200
    end

    def unhideOrHideFamily
        if params[:hide].downcase == 'true'
            @page.update(hideFamily: true)
        else
            @page.update(hideFamily: false)
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
            if params[:account_type] == "1"
                @user = User.find(params[:user_id])
            else
                @user = AlmUser.find(params[:user_id])
            end
        end

        if !user().has_role? :pageadmin, @page 
            return render json: {status: "Access Denied"}, status: 401
        end
    end

    def post_params
        params.permit(:page_type, :page_id, :body, :location, :longitude, :latitude, imagesOrVideos: [])
    end
end
