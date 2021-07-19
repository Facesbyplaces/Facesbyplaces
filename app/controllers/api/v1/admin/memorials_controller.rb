class Api::V1::Admin::MemorialsController < ApplicationController
    before_action :admin_only

    # Memorial
    def usersSelection #for create memorial users selection
        users = User.all.where.not(guest: true, username: "admin")
        # _except(User.guest).order("users.id DESC")
        alm_users = AlmUser.all

        allUsers = users.order("users.id DESC") + alm_users.order("alm_users.id DESC")
        render json: {success: true,  users: allUsers }, status: 200
    end

    # Index Memorials
    def allMemorials
        render json: {
            # itemsremaining:  itemsRemaining,
            memorials: {
                blm: blm_memorials,
                alm: alm_memorials
            }
        }
    end
    # Search Memorial
    def searchMemorial
        memorials = PgSearch.multisearch(params[:keywords]).where(searchable_type: ['Memorial', 'Blm'])
        memorials = memorials.page(params[:page]).per(numberOfPage)

        if memorials.total_count == 0 || (memorials.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif memorials.total_count < numberOfPage
            itemsremaining = memorials.total_count 
        else
            itemsremaining = memorials.total_count - (params[:page].to_i * numberOfPage)
        end

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

        render json: {  itemsremaining:  itemsremaining,
                        memorials: memorials,
                        page_type: page_type,
                    }
    end
    # Create Memorial
    def createMemorial
        #IF MEMORIAL IS OF TYPE ALM
        if params[:page_type].to_i == 2
            memorial = Memorial.new(memorial_params)
            # get user for associating them to the memorial
            user = AlmUser.find(params[:user_id])
    
            # check if the params sent is valid or not
            check = params_presence(params[:memorial])
            if check == true
                # set privacy to public
                memorial.privacy = "public"
                memorial.hideFamily = false
                memorial.hideFriends = false
                memorial.hideFollowers = false
    
                # save memorial
                memorial.save
    
                # save the owner of the user
                pageowner = Pageowner.new(account_type:  "AlmUser", account_id: user.id, view: 0)
                memorial.pageowner = pageowner
    
                # save relationship of the user to the page
                relationship = memorial.relationships.new(account: user, relationship: params[:relationship])
                relationship.save 
    
                # Make the user as admin of the 
                user.add_role "pageadmin", memorial
    
                render json: {memorial: MemorialSerializer.new( memorial ).attributes, status: :created}
    
                # Notify all Users
                blmUsers = User.joins(:notifsetting).where("notifsettings.newMemorial": true)
                almUsers = AlmUser.joins(:notifsetting).where("notifsettings.newMemorial": true).where("notifsettings.account_type != 'AlmUser' AND notifsettings.account_id != #{user().id}")
                
                blmUsersDeviceToken = []
                blmUsers.each do |user|
                    Notification.create(recipient: user, actor: user(), read: false, action: "#{user().first_name} created a new page", postId: memorial.id, notif_type: 'Memorial')
                    blmUsersDeviceToken << user.device_token
                end
    
                almUsersDeviceToken = []
                almUsers.each do |user|
                    Notification.create(recipient: user, actor: user(), read: false, action: "#{user().first_name} created a new page", postId: memorial.id, notif_type: 'Memorial')
                    almUsersDeviceToken << user.device_token
                end
    
                device_tokens = almUsersDeviceToken + blmUsersDeviceToken
                title = "New Memorial Page"
                message = "#{user().first_name} created a new page"
                PushNotification(device_tokens, title, message, user, user(), memorial.id, "Memorial", " ")
            else
                render json: {status: "#{check} is empty"}
            end
        #IF MEMORIAL IS OF TYPE BLM    
        elsif params[:page_type] == 1 || "1"
            # create new blm page
            blm = Blm.new(blm_params)
            # get user for associating them to a memorial
            user = User.find(params[:user_id])

            # check if the params sent is valid or not
            check = params_presence(params[:blm])
            if check == true
                # set privacy to public
                blm.privacy = "public"
                blm.hideFamily = false
                blm.hideFriends = false
                blm.hideFollowers = false
    
                # save blm
                if blm.save 
    
                    # save the owner of the user
                    pageowner = Pageowner.new(account_type:  "User", account_id: user().id, view: 0)
                    blm.pageowner = pageowner
    
                    # save relationship of the user to the page
                    relationship = blm.relationships.new(account: user, relationship: params[:relationship])
                    if relationship.save 
    
                        # Make the user as admin of the 
                        user.add_role "pageadmin", blm
    
                        render json: {blm: BlmSerializer.new( blm ).attributes, status: :created}
    
                        # Notify all Users
                        blmUsers = User.joins(:notifsetting).where("notifsettings.newMemorial": true).where("notifsettings.account_type != 'User' AND notifsettings.account_id != #{user().id}")
                        almUsers = AlmUser.joins(:notifsetting).where("notifsettings.newMemorial": true)
                        
                        blmUsersDeviceToken = []
                        blmUsers.each do |user|
                            Notification.create(recipient: user, actor: user(), read: false, action: "#{user().first_name} created a new page", postId: blm.id, notif_type: 'Blm')
                            blmUsersDeviceToken << user.device_token
                        end
    
                        almUsersDeviceToken = []
                        almUsers.each do |user|
                            Notification.create(recipient: user, actor: user(), read: false, action: "#{user().first_name} created a new page", postId: blm.id, notif_type: 'Blm')
                            almUsersDeviceToken << user.device_token
                        end
    
                        device_tokens = almUsersDeviceToken + blmUsersDeviceToken
                        title = "New Memorial Page"
                        message = "#{user().first_name} created a new page"
                        PushNotification(device_tokens, title, message, user, user(), blm.id, "Blm", " ")
                    else
                        render json: {errors: relationship.errors}, status: 500
                    end
                else  
                    render json: {errors: blm.errors}, status: 500
                    blm.destroy
                end
            else
                render json: {status: "#{check} is empty"}
            end
        else
            puts params[:page_type].class
        end
    end
    # Show Memorial
    def showMemorial
        memorial = Pageowner.where(page_id: params[:id]).where(page_type: params[:page]).first
        
        if memorial
            render json: memorial
        else
            render json: {errors: "Page not found"}
        end
    end
    # Update Memorial
    def updateMemorial
        memorial = Memorial.find(params[:id])
        # user = User.find(params[:user_id]) ? User.find(params[:user_id]) : AlmUser.find(params[:user_id])
        
        # check if data sent is empty or not
        check = params_presence(params)
        if check == true
            # Update memorial details
            memorial.update(memorial_details_params)

            # Update relationship of the current page admin to the page
            # memorial.relationships.where(account: user).first.update(relationship: params[:relationship])

            return render json: {memorial: MemorialSerializer.new( memorial ).attributes, status: "updated details"}
        else
            return render json: {error: "#{check} is empty"}
        end
    end
    # Update Memorial Images
    def updateMemorialImages
        memorial = Memorial.find(params[:id])

        if memorial.update(memorial_images_params)
            return render json: {memorial: MemorialSerializer.new( memorial ).attributes, status: "updated images"}
        else
            return render json: {status: 'Error'}
        end
    end

    # BLM
    # Update BLM
    def updateBlm
        blm = Blm.find(params[:id])
        
        # check if data sent is empty or not
        check = params_presence(params)
        if check == true
            # Update blm details
            blm.update(blm_details_params)

            # Update relationship of the current page admin to the page
            # blm.relationships.where(account: user()).first.update(relationship: params[:relationship])

            return render json: {blm: BlmSerializer.new( blm ).attributes, status: "updated details"}
        else
            return render json: {error: "#{check} is empty"}
        end
    end
    # Update BLM Images
    def updateBlmImages
        blm = Blm.find(params[:id])
        
        # check if memorial is updated successfully
        if blm.update(blm_images_params)
            return render json: {blm: BlmSerializer.new( blm ).attributes, status: "updated images"}
        else
            return render json: {status: 'Error'}
        end
    end  
    # Delete Memorial
    def deleteMemorial
        if params[:page] == "Memorial"
            memorial = Memorial.find(params[:id])
            memorial.destroy()

            adminsRaw = AlmRole.where(resource_type: 'Memorial', resource_id: params[:id]).joins("INNER JOIN alm_users_alm_roles ON alm_roles.id = alm_users_alm_roles.alm_role_id").pluck("alm_users_alm_roles.alm_user_id")

            adminsRaw.each do |admin_id|
                AlmUser.find(admin_id).roles.where(resource_type: 'Memorial', resource_id: params[:id]).first.destroy 
            end
            
            render json: {status: "deleted"}
        elsif params[:page] == "Blm"
            blm = Blm.find(params[:id])
            blm.destroy()

            adminsRaw = Blm.find(params[:page_id]).roles.first.users.pluck('id')

            adminsRaw.each do |admin_id|
                User.find(admin_id).roles.where(resource_type: 'Blm', resource_id: params[:id]).first.destroy 
            end
            
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

    def blm_memorials
        # BLM Memorials
        blm_memorials = Blm.all
        # BLM
        blm_memorials = blm_memorials.page(params[:page]).per(numberOfPage)
        if blm_memorials.total_count == 0 || (blm_memorials.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsRemaining = 0
        elsif blm_memorials.total_count < numberOfPage
            itemsRemaining = blm_memorials.total_count 
        else
            itemsRemaining = blm_memorials.total_count - (params[:page].to_i * numberOfPage)
        end

        return blmMemorials = ActiveModel::SerializableResource.new(
                            blm_memorials, 
                            each_serializer: BlmSerializer
                        )
    end

    def alm_memorials
        #ALM Memorials
        alm_memorials = Memorial.all
        # ALM
        alm_memorials = alm_memorials.page(params[:page]).per(numberOfPage)
        if alm_memorials.total_count == 0 || (alm_memorials.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsRemaining = 0
        elsif alm_memorials.total_count < numberOfPage
            itemsRemaining = alm_memorials.total_count 
        else
            itemsRemaining = alm_memorials.total_count - (params[:page].to_i * numberOfPage)
        end

        return almMemorials = ActiveModel::SerializableResource.new(
                            alm_memorials, 
                            each_serializer: MemorialSerializer
                        )

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

    def admin_only
        unless user().has_role? :admin 
            return render json: {status: "Must be an admin to continue"}, status: 401
        end
    end
end