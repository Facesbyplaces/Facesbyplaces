class Api::V1::Admin::AdminController < ApplicationController
    before_action :check_user
    before_action :admin_only

    # USER
    def allUsers
        users = User.all.where.not(guest: true, username: "admin")
        # _except(User.guest).order("users.id DESC")
        alm_users = AlmUser.all

        # BLM Users
        users = users.page(params[:page]).per(numberOfPage)
        if users.total_count == 0 || (users.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif users.total_count < numberOfPage
            itemsremaining = users.total 
        else
            itemsremaining = users.total_count - (params[:page].to_i * numberOfPage)
        end

        # ALM Users
        alm_users = alm_users.page(params[:page]).per(numberOfPage)
        if alm_users.total_count == 0 || (alm_users.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif alm_users.total_count < numberOfPage
            itemsremaining = alm_users.total 
        else
            itemsremaining = alm_users.total_count - (params[:page].to_i * numberOfPage)
        end

        allUsers = users.order("users.id DESC") + alm_users.order("alm_users.id DESC")

        render json: {  itemsremaining:  itemsremaining,
                        users: ActiveModel::SerializableResource.new(
                                    allUsers, 
                                    each_serializer: UserSerializer
                                ),
                        user: user,
                    }
    end

    def showUser
        # image = user.image ? rails_blob_url(user.image) : nil
        if params[:account_type] == '1'
            user = User.find(params[:id]) 
        else
            user = AlmUser.find(params[:id]) 
        end

        render json: UserSerializer.new( user ).attributes
        # UserSerializer.new( user ).attributes
        # id:             user.id, 
            # username:       user.username, 
            # first_name:     user.first_name, 
            # last_name:      user.last_name, 
            # phone_number:   user.phone_number, 
    end

    def editUser
        if params[:account_type].to_i == 1
            user = User.find(params[:id])
        else
            user = AlmUser.find(params[:id])
        end

        if user != nil
            user.update(editUser_params)
            if user.errors.present?
                render json: {success: false, errors: user.errors.full_messages, status: 404}, status: 200
            else
                render json: {success: true, message: "Successfully Edited User", user: user, status: 200}, status: 200
            end
        else
            render json: {error: "pls login"}, status: 422
        end
    end

    def deleteUser
        if params[:account_type].to_i == 1
            user = User.find(params[:id])
        else
            user = AlmUser.find(params[:id])
        end

        if user != nil
            user.destroy!
            if user.errors.present?
                render json: {success: false, errors: user.errors.full_messages, status: 404}, status: 200
            else
                render json: {success: true, message: "Successfully Deleted User", user: user, status: 200}, status: 200
            end
        else
            render json: {error: "pls login"}, status: 422
        end
    end

    def searchUsers
        users = PgSearch.multisearch(params[:keywords]).where(searchable_type: ['AlmUser', 'User']).map{|searchObject| 
            if searchObject.searchable_type == 'User'
                User.find(searchObject.searchable_id)
            else
                AlmUser.find(searchObject.searchable_id)
            end
        }.flatten.uniq

        users = Kaminari.paginate_array(users).page(params[:page]).per(numberOfPage)
        if users.total_count == 0 || (users.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif users.total_count < numberOfPage
            itemsremaining = users.total_count 
        else
            itemsremaining = users.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        users: ActiveModel::SerializableResource.new(
                            users, 
                            each_serializer: UserSerializer
                        )
                    }
    end

    def contactUser
        message = params[:message]
        if params[:account_type] == '1'
            userEmail = User.find(params[:id]).email
        else
            userEmail = AlmUser.find(params[:id]).email
        end
        subject = params[:subject]

        ContactUserMailer.with(message: message, email: userEmail, subject: subject).contact_user.deliver_later

        render json: {status: "Email Sent"}
    end

    def showPost
        post = Post.find(params[:id])

        render json: PostSerializer.new( post ).attributes
    end

    def deletePost
        post = Post.find(params[:id])
        post.destroy 

        render json: {status: :deleted}
    end

    def searchPost
        postsId = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Post').pluck('searchable_id')

        posts = Post.where(id: postsId)
        
        posts = posts.page(params[:page]).per(numberOfPage)
        if posts.total_count == 0 || (posts.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif posts.total_count < numberOfPage
            itemsremaining = posts.total_count 
        else
            itemsremaining = posts.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        posts: ActiveModel::SerializableResource.new(
                            posts, 
                            each_serializer: PostSerializer
                        )
                    }
    end
    
    # Memorial
        # Index Memorials
     def allMemorials
        # BLM Memorials
        blm_memorials = Blm.all
        #ALM Memorials
        alm_memorials = Memorial.all

        # BLM
        blm_memorials = blm_memorials.page(params[:page]).per(numberOfPage)
        if blm_memorials.total_count == 0 || (blm_memorials.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsRemaining = 0
        elsif blm_memorials.total_count < numberOfPage
            itemsRemaining = blm_memorials.total_count 
        else
            itemsRemaining = blm_memorials.total_count - (params[:page].to_i * numberOfPage)
        end

        blmMemorials = ActiveModel::SerializableResource.new(
                            blm_memorials, 
                            each_serializer: BlmSerializer
                        )

         # ALM
         alm_memorials = alm_memorials.page(params[:page]).per(numberOfPage)
         if alm_memorials.total_count == 0 || (alm_memorials.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsRemaining = 0
        elsif alm_memorials.total_count < numberOfPage
            itemsRemaining = alm_memorials.total_count 
        else
            itemsRemaining = alm_memorials.total_count - (params[:page].to_i * numberOfPage)
        end

        almMemorials = ActiveModel::SerializableResource.new(
                            alm_memorials, 
                            each_serializer: MemorialSerializer
                        )

        # render json: {  itemsremaining:  itemsremaining,
        #                 memorials: memorials, 
        #                 user: user,
        #             }

        render json: {
            itemsremaining:  itemsRemaining,
            memorials: {
                blm: blm_memorials,
                alm: alm_memorials
            },
            user: user,
        }
        
    end

    def createMemorial
        #IF MEMORIAL IS OF TYPE ALM
        if params[:page_type].to_i == 2
            memorial = Memorial.new(memorial_params)
            # get user for associating them to a memorial
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
                
                # Tell the Mailer to send link to register stripe user account after save
                redirect_uri = Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :redirect_uri)
                client_id = Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :client_id)
                SendStripeLinkMailer.send_memorial_link(redirect_uri, client_id, user(), memorial.id).deliver_now
    
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
                PushNotification(device_tokens, title, message)
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
    
                        # Tell the Mailer to send link to register stripe user account after save
                        redirect_uri = Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :redirect_uri)
                        client_id = Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :client_id)
                        SendStripeLinkMailer.send_blm_link(redirect_uri, client_id, user(), blm.id).deliver_now
                        
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
                        PushNotification(device_tokens, title, message)
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
    def updateMemorialImages
        memorial = Memorial.find(params[:id])

        if memorial.update(memorial_images_params)
            return render json: {memorial: MemorialSerializer.new( memorial ).attributes, status: "updated images"}
        else
            return render json: {status: 'Error'}
        end
    end
    
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
    def updateBlmImages
        blm = Blm.find(params[:id])
        
        # check if memorial is updated successfully
        if blm.update(blm_images_params)
            return render json: {blm: BlmSerializer.new( blm ).attributes, status: "updated images"}
        else
            return render json: {status: 'Error'}
        end
    end 

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

    def deleteMemorial
        memorial = Pageowner.where(page_id: params[:id]).where(page_type: params[:page]).first
        if memorial
            memorial.page.destroy 
            render json: {status: :deleted}
        else
            render json: {status: "page not found"}
        end
    end

    def allReports
        reports = Report.all 
                            
        reports = reports.page(params[:page]).per(numberOfPage)
        if reports.total_count == 0 || (reports.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif reports.total_count < numberOfPage
            itemsremaining = reports.total_count 
        else
            itemsremaining = reports.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        reports: reports
                    }
    end

    def showReport
        report = Report.find(params[:id])

        render json: report
    end

    def transactions
        transactions = Transaction.where(page_type: params[:page_type], page_id: params[:page_id])

        render json: transactions
    end

    def show_transaction
        transaction = Transaction.find(params[:transaction_id])

        render json: transaction
    end

    def PushNotification(device_tokens, title, message)
        require 'fcm'
        puts        "\n-- Device Token : --\n#{device_tokens}"
        logger.info "\n-- Device Token : --\n#{device_tokens}"

        fcm_client = FCM.new(Rails.application.credentials.dig(:firebase, :server_key))
        options = { notification: { 
                        body: 'message',
                        title: 'title',
                    }
                }
        begin
            response = fcm_client.send(device_tokens, options)
        rescue StandardError => err
            puts        "\n-- PushNotification : Error --\n#{err}"
            logger.info "\n-- PushNotification : Error --\n#{err}"
        end
  
        puts response
    end


    private

    def editUser_params
        params.permit(:id, :account_type, :username, :first_name, :last_name, :phone_number)
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

    def admin_only
        if !user.has_role? :admin 
            return render json: {status: "Must be an admin to continue"}, status: 401
        end
    end
end
