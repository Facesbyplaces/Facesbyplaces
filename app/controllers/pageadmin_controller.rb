class PageadminController < ApplicationController
    before_action :set_up, except: [:removeFamily, :removeFriend]

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
        if user().has_role? :pageadmin, @page
            # add new relationship to the page
            family = @page.relationships.new(relationship: params[:relationship], user: @user)
            # save relationship
            if family.save 
                render json: {status: "Added Successfuly", relationship_id: family.id}
            else
                render json: {status: "Error"}
            end
        else
            render json: {status: "Access Denied"}
        end
    end

    def removeFamily
        if user().has_role? :pageadmin, @page
            family = Relationship.find(params[:id])
            family.destroy 
            render json: {status: "Deleted Successfully"}
        else
            render json: {status: "Access Denied"}
        end
    end

    def addFriend
        if user().has_role? :pageadmin, @page
            # add new relationship to the page
            friend = @page.relationships.new(relationship: params[:relationship], user: @user)
            # save relationship
            if friend.save 
                render json: {status: "Added Successfuly", relationship_id: family.id}
            else
                render json: {status: "Error"}
            end
        else
            render json: {status: "Access Denied"}
        end
    end

    def removeFriend
        if user().has_role? :pageadmin, @page
            friend = Relationship.find(params[:id])
            friend.destroy 
            render json: {status: "Deleted Successfully"}
        else
            render json: {status: "Access Denied"}
        end
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
        @user = User.find(params[:id])
    end
end
