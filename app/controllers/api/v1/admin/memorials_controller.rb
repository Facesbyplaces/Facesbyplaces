class Api::V1::Admin::MemorialsController < ApplicationController
    before_action :admin_only
    before_action :set_memorial, only: [:updateMemorial, :updateMemorialImages, :updateBlm, :updateBlmImages, :showMemorial, :deleteMemorial]
    # before_action :set_blm, only: [:updateBlm, :updateBlmImages]

    # Memorial
    def usersSelection #for create memorial users selection
        users = User.all.where.not(guest: true, username: "admin")
        alm_users = AlmUser.all

        allUsers = users.order("users.id DESC") + alm_users.order("alm_users.id DESC")
        render json: {success: true,  users: allUsers }, status: 200
    end

    def allMemorials
        @blm_memorials = fetched_blm_memorials
        blmMemorials = ActiveModel::SerializableResource.new(
                            @blm_memorials, 
                            each_serializer: BlmSerializer
                        )

        @alm_memorials = fetched_alm_memorials
        almMemorials = ActiveModel::SerializableResource.new(
                            @alm_memorials, 
                            each_serializer: MemorialSerializer
                        )
        render json: {
            itemsremaining:  itemsRemaining(@blm_memorials),
            memorials: {
                blm: blmMemorials,
                alm: almMemorials
            }
        }
    end
    
    def searchMemorial
        @memorials = fetched_searched_memorials

        memorials = @memorials.collect do |memorial|
            if memorial.searchable_type == 'Blm'
                memorial = Blm.find(memorial.searchable_id)
                set_page_type(1)
                ActiveModel::SerializableResource.new(
                    memorial, 
                    each_serializer: BlmSerializer
                )
            else
                memorial = Memorial.find(memorial.searchable_id)
                set_page_type(2)
                ActiveModel::SerializableResource.new(
                    memorial, 
                    each_serializer: MemorialSerializer
                )
            end
        end

        render json: {  itemsremaining:  itemsRemaining(@memorials),
                        memorials: memorials,
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
            check = params_presence(params[:memorial])
            if check == true
                save_memorial(memorial, user)
                render json: {memorial: MemorialSerializer.new( memorial ).attributes, status: :created}
            else
                render json: {status: "#{check} is empty"}
            end
        #IF MEMORIAL IS OF TYPE BLM    
        elsif params[:page_type].to_i == 1
            # create new blm page
            blm = Blm.new(blm_params)
            # get user for associating them to a memorial
            user = User.find(params[:user_id])

            # check if the params sent is valid or not
            check = params_presence(params[:blm])
            if check == true
                save_memorial(blm, user)
                render json: {blm: BlmSerializer.new( blm ).attributes, status: :created}
            else
                render json: {status: "#{check} is empty"}
            end
        else
            puts params[:page_type].class
        end
    end
    
    def showMemorial
        # memorial = Blm.find(params[:id])
        # where(page_id: params[:id]).where(page_type: params[:page]).first
        
        if @memorial
            render json: @memorial
        else
            render json: {errors: "Page not found"}, status: 404
        end
    end
    
    def updateMemorial
        # check if data sent is empty or not
        check = params_presence(params)
        if check == true
            # Update memorial details
            @memorial.update(memorial_details_params)

            # Update relationship of the current page admin to the page
            # memorial.relationships.where(account: user).first.update(relationship: params[:relationship])

            return render json: {memorial: MemorialSerializer.new( @memorial ).attributes, status: "updated details"}
        else
            return render json: {error: "#{check} is empty"}
        end
    end
    
    def updateMemorialImages
        if @memorial.update(memorial_images_params)
            return render json: {memorial: MemorialSerializer.new( @memorial ).attributes, status: "updated images"}
        else
            return render json: {status: 'Error'}
        end
    end

    def updateBlm
        # check if data sent is empty or not
        check = params_presence(params)
        if check == true
            # Update blm details
            @blm.update(blm_details_params)

            # Update relationship of the current page admin to the page
            # blm.relationships.where(account: user()).first.update(relationship: params[:relationship])

            return render json: {blm: BlmSerializer.new( @blm ).attributes, status: "updated details"}
        else
            return render json: {error: "#{check} is empty"}
        end
    end

    def updateBlmImages
        # check if memorial is updated successfully
        if @blm.update(blm_images_params)
            return render json: {blm: BlmSerializer.new( @blm ).attributes, status: "updated images"}
        else
            return render json: {status: 'Error'}
        end
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

            @blm.destroy()
            
            render json: {status: "deleted"}
        end

        # memorial = Pageowner.where(page_id: params[:id]).where(page_type: params[:page]).first
        # if memorial
        #     memorial.page.destroy 
        #     adminsRaw = AlmRole.where(resource_type: 'Memorial', resource_id: params[:id]).joins("INNER JOIN alm_users_alm_roles ON alm_roles.id = alm_users_alm_roles.alm_role_id").pluck("alm_users_alm_roles.alm_user_id")

        #     adminsRaw.each do |admin_id|
        #         AlmUser.find(admin_id).roles.where(resource_type: 'Memorial', resource_id: params[:id]).first.destroy 
        #     end
        #     render json: {status: :deleted}
        # else
        #     render json: {status: "page not found"}
        # end
    end

    private

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

    def notif_type
        if params[:page_type].to_i == 2
            return 'Memorial'
        else
            return 'Blm'
        end
    end

    def set_memorial
        if params[:page].present? && params[:page] === "Blm" || blm_details_params[:precinct].present?
            @blm = Blm.find(params[:id])
        else
            @memorial = Memorial.find(params[:id])
        end
    end

    def set_blm
        @blm = Blm.find(params[:id])
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
            send_notif(user, message, memorial, notif_type)
        end

        almUsersDeviceToken = []
        almUsers.each do |user|
            message = "#{user.first_name} created a new page"
            send_notif(user, message, memorial, notif_type)
        end
    end

    def send_notif(user, message, memorial, notif_type)
        Notification.create(recipient: user, actor: user(), read: false, action: message, postId: memorial.id, notif_type: notif_type)
        
        # Send push notif
        device_tokens = user.device_token
        title = "New Memorial Page"
        PushNotification(device_tokens, title, message, user, user(), memorial.id, notif_type, " ") 
    end

    def fetched_blm_memorials
        blm_memorials = Blm.all
        return blm_memorials = blm_memorials.page(params[:page]).per(numberOfPage)        
    end

    def fetched_alm_memorials
        alm_memorials = Memorial.all
        return alm_memorials = alm_memorials.page(params[:page]).per(numberOfPage)
    end

    def fetched_searched_memorials
        memorials = PgSearch.multisearch(params[:keywords]).where(searchable_type: ['Memorial', 'Blm'])
        return memorials = memorials.page(params[:page]).per(numberOfPage)
    end

    def set_page_type(i)
        @page_type = i
    end

    def collect_memorials(memorials)
        page_type = ''
        memorials = memorials.collect do |memorial|
            if memorial.searchable_type == 'Blm'
                memorial = Blm.find(memorial.searchable_id)
                page_type = 1
                ActiveModel::SerializableResource.new(
                    memorial, 
                    each_serializer: BlmSerializer
                )
            else
                memorial = Memorial.find(memorial.searchable_id)
                page_type = 2
                ActiveModel::SerializableResource.new(
                    memorial, 
                    each_serializer: MemorialSerializer
                )
            end
        end
        return memorials
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

    def admin_only
        unless user().has_role? :admin 
            return render json: {status: "Must be an admin to continue"}, status: 401
        end
    end
end
