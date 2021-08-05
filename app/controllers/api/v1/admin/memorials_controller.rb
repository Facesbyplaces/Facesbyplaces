class Api::V1::Admin::MemorialsController < ApplicationController
    include Memorialable
    before_action :verify_admin
    before_action :set_users, only: [:usersSelection]    
    before_action :set_memorials, only: [:allMemorials]
    before_action :set_blms, only: [:allMemorials]
    before_action :set_search_memorials, only: [:searchMemorial]
    before_action :set_memorial, only: [:showMemorial, :updateMemorial, :updateMemorialImages, :updateBlm, :updateBlmImages, :deleteMemorial]
    before_action :set_notif_type, only: [:createMemorial]
    # Memorial
    def usersSelection #for create memorial users selection
        render json: {success: true,  users: @users }, status: 200
    end

    def allMemorials
        render json: {
            itemsremaining:  itemsRemaining(@blm_memorials),
            memorials: {
                blm: @blms,
                alm: @memorials
            }
        }
    end
    
    def searchMemorial
        render json: {  itemsremaining:  itemsRemaining(@memorials),
                        memorials: @searched_memorials,
                        page_type: @page_type,
                    }
    end
    
    def createMemorial
        #IF MEMORIAL IS OF TYPE ALM
        if params[:page_type].to_i == 2
            # create new alm page
            memorial = Memorial.new(memorial_params)
            # get user for associating them to the memorial
            user = AlmUser.find(params[:user_id])

            # check if the params sent is valid or not
            return render json: {status: "Params is empty"} unless params_presence(memorial_params)
            save_memorial(memorial, user)
            render json: {memorial: MemorialSerializer.new( memorial ).attributes, status: :created}
        #IF MEMORIAL IS OF TYPE BLM    
        elsif params[:page_type].to_i == 1
            # create new blm page
            blm = Blm.new(blm_params)
            # get user for associating them to a memorial
            user = User.find(params[:user_id])

            # check if the params sent is valid or not
            return render json: {status: "Params is empty"} unless params_presence(blm_params)
            save_memorial(blm, user)
            render json: {blm: BlmSerializer.new( blm ).attributes, status: :created}
        end
    end
    
    def showMemorial
        return render json: {errors: "Page not found"}, status: 404 unless @memorial
        render json: @memorial
    end
    
    def updateMemorial
        return render json: {error: "Params is empty"} unless params_presence(memorial_details_params) == true
        @memorial.update(memorial_details_params)
        # Update relationship of the current page admin to the page
        # memorial.relationships.where(account: user).first.update(relationship: params[:relationship])
        return render json: {memorial: MemorialSerializer.new( @memorial ).attributes, status: "updated details"}
    end
    
    def updateMemorialImages
        return render json: {status: 'Error'} unless @memorial.update(memorial_images_params)
        render json: {memorial: MemorialSerializer.new( @memorial ).attributes, status: "updated images"}
    end

    def updateBlm
        return render json: {error: "Params is empty"} unless params_presence(blm_details_params) == true
        @memorial.update(blm_details_params)
        # Update relationship of the current page admin to the page
        # blm.relationships.where(account: user()).first.update(relationship: params[:relationship])
        render json: {blm: BlmSerializer.new( @memorial ).attributes, status: "updated details"}
    end

    def updateBlmImages
        return render json: {status: 'Error'} unless @memorial.update(blm_images_params)
        render json: {blm: BlmSerializer.new( @memorial ).attributes, status: "updated images"}
    end  
    
    def deleteMemorial
        if params[:page] === "Memorial"
            # @memorial = set_memorial

            adminsRaw = AlmRole.where(resource_type: 'Memorial', resource_id: params[:id]).joins("INNER JOIN alm_users_alm_roles ON alm_roles.id = alm_users_alm_roles.alm_role_id").pluck("alm_users_alm_roles.alm_user_id")
            adminsRaw.each do |admin_id|
                AlmUser.find(admin_id).roles.where(resource_type: 'Memorial', resource_id: params[:id]).first.destroy 
            end

            @memorial.destroy()
            
            render json: {status: "deleted"}
        elsif params[:page] === "Blm"
            # @blm = set_blm

            adminsRaw = Blm.find(params[:id]).roles.first.users.pluck('id')
            adminsRaw.each do |admin_id|
                User.find(admin_id).roles.where(resource_type: 'Blm', resource_id: params[:id]).first.destroy 
            end

            @memorial.destroy()
            
            render json: {status: "deleted"}
        end
    end

    private
    def verify_admin
        return render json: {status: "Must be an admin to continue"}, status: 401 unless user().has_role? :admin 
    end

    def memorial_params
        params.require(:memorial).permit(:name, :description, :birthplace, :dob, :rip, :cemetery, :country, :backgroundImage, :profileImage, :longitude, :latitude, imagesOrVideos: [])
    end

    def memorial_images_params
        params.permit(:backgroundImage, :profileImage, imagesOrVideos: [])
    end

    def blm_params
        params.require(:blm).permit(:name, :description, :location, :precinct, :dob, :rip, :state, :country,  :backgroundImage, :profileImage, :longitude, :latitude, imagesOrVideos: [])
    end

    def blm_images_params
        params.permit(:backgroundImage, :profileImage, imagesOrVideos: [])
    end

    def memorial_details_params
        params.permit(:birthplace, :dob, :rip, :cemetery, :country, :name, :description, :longitude, :latitude)
    end

    def blm_details_params
        params.permit(:name, :description, :location, :precinct, :dob, :rip, :state, :country, :longitude, :latitude)
    end

    def itemsRemaining(data)
        if data.total_count == 0 || (data.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsRemaining = 0
        elsif data.total_count < numberOfPage
            itemsRemaining = data.total_count 
        else
            itemsRemaining = data.total_count - (params[:page].to_i * numberOfPage)
        end
    end

    def save_memorial(memorial, user)        
        set_privacy(memorial)

        # save memorial
        if memorial.save
            # save the owner of the user
            save_owner(memorial, user)
            # save relationship of the user to the page
            save_relationship(memorial, user)
        else  
            render json: {errors: memorial.errors}, status: 500
            memorial.destroy
        end
    end

    def set_privacy(memorial)
        memorial.privacy = "public"
        memorial.hideFamily = false
        memorial.hideFriends = false
        memorial.hideFollowers = false
    end

    def save_owner(memorial, user)
        account_type = user.account_type == 2 ? "AlmUser" : "User"
        pageowner = Pageowner.new(account_type: account_type, account_id: user.id, view: 0)
        memorial.pageowner = pageowner
    end

    def save_relationship(memorial, user)
        relationship = memorial.relationships.new(account: user, relationship: params[:relationship])
        if relationship.save
            # Net user as admin
            set_admin(memorial, user)
            # Notify all Users
            notify_users(memorial, user)
        else
            return render json: {errors: relationship.errors}, status: 500
        end
    end

    def set_admin(memorial, user)
        user.add_role "pageadmin", memorial
    end

    def notify_users(memorial, user2)
        # Notify all Users
        if params[:page_type].to_i == 2 
            blmUsers = User.joins(:notifsetting).where("notifsettings.newMemorial": true).where("notifsettings.account_type != 'User' AND notifsettings.account_id != #{user2.id}")
            almUsers = AlmUser.joins(:notifsetting).where("notifsettings.newMemorial": true)
        else
            blmUsers = User.joins(:notifsetting).where("notifsettings.newMemorial": true)
            almUsers = AlmUser.joins(:notifsetting).where("notifsettings.newMemorial": true).where("notifsettings.account_type != 'AlmUser' AND notifsettings.account_id != #{user2.id}")
        end
        
        blmUsersDeviceToken = []
        blmUsers.each do |user|
            message = "#{user.first_name} created a new page"
            send_notif(user, message, memorial)
        end

        almUsersDeviceToken = []
        almUsers.each do |user|
            message = "#{user.first_name} created a new page"
            send_notif(user, message, memorial)
        end
    end

    def send_notif(user, message, memorial)
        Notification.create(recipient: user, actor: user(), read: false, action: message, postId: memorial.id, notif_type: @notif_type)
        
        # Send push notif
        device_tokens = user.device_token
        title = "New Memorial Page"
        PushNotification(device_tokens, title, message, user, user(), memorial.id, @notif_type, " ") 
    end
end
