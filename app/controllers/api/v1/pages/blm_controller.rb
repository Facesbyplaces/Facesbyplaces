class Api::V1::Pages::BlmController < ApplicationController
    before_action :check_user, except: [:show]
    before_action :verify_user_account_type, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages, :create]
    before_action :authorize, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages]

    def show
        blm = Blm.find(params[:id])
        
        # add count to view of page
        page = Pageowner.where(page_type: 'Blm', page_id: blm.id).first

        if page == nil
            return render json: {errors: "Page not found"}, status: 400
        end
        
        if page.view == nil
            page.update(view: 1)
        else
            page.update(view: (page.view + 1))
        end
        
        render json: {blm: BlmSerializer.new( blm ).attributes}
    end

    def create
        # create new blm page
        blm = Blm.new(blm_params)
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

                blm.update(latitude: blm_params[:latitude], longitude: blm_params[:longitude])
                # save relationship of the user to the page
                relationship = blm.relationships.new(account: user(), relationship: params[:relationship])
                if relationship.save 

                    # Make the user as admin of the 
                    user().add_role "pageadmin", blm

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
    end

    def editDetails
        blm = Blm.find(params[:id])
        # render memorial details that be editted
        render json: {blm: BlmSerializer.new( blm ).attributes}
    end

    def updateDetails
        blm = Blm.find(params[:id])
        
        # check if data sent is empty or not
        check = params_presence(params)
        if check == true
            # Update blm details
            blm.update(blm_details_params)

            # Update relationship of the current page admin to the page
            blm.relationships.where(account: user()).first.update(relationship: params[:relationship])

            return render json: {blm: BlmSerializer.new( blm ).attributes, status: "updated details"}
        else
            return render json: {error: "#{check} is empty"}
        end
    end

    def editImages
        blm = Blm.find(params[:id])
        # render memorial images that be editted
        render json: {blm: BlmSerializer.new( blm ).attributes}
    end

    def updateImages
        blm = Blm.find(params[:id])
        
        # check if memorial is updated successfully
        if blm.update(blm_images_params)
            return render json: {blm: BlmSerializer.new( blm ).attributes, status: "updated images"}
        else
            return render json: {status: 'Error'}
        end
    end

    def delete
        blm = Blm.find(params[:id])
        blm.destroy()

        adminsRaw = Blm.find(params[:page_id]).roles.first.users.pluck('id')

        adminsRaw.each do |admin_id|
            User.find(admin_id).roles.where(resource_type: 'Blm', resource_id: params[:id]).first.destroy 
        end
        
        render json: {status: "deleted"}
    end

    def setPrivacy
        blm = Blm.find(params[:id])
        blm.update(privacy: params[:privacy])
        render json: {status: :success}
    end

    def setRelationship   # for friends and families
        blm = Blm.find(params[:id])

        if blm.relationships.where(account: user()).first
            blm.relationships.where(account: user()).first.update(relationship: params[:relationship])

            render json: {status: :success}
        else
            render json: {status: "You're not part of the family or friends"}
        end
    end

    def leaveBLM        # leave blm page for family and friends
        blm = Blm.find(params[:id])
        if blm.relationships.where(account: user()).first != nil
            # check if the user is a pageadmin
            if user().has_role? :pageadmin, blm
                if User.with_role(:pageadmin, blm).count != 1
                    # remove user from the page
                    if blm.relationships.where(account: user()).first.destroy 
                        # remove role as a page admin
                        user().remove_role :pageadmin, blm
                        render json: {}, status: 200
                    else
                        render json: {}, status: 500
                    end
                else
                    render json: {}, status: 406
                end
            else
                # remove user from the page
                if blm.relationships.where(account: user()).first.destroy 
                    render json: {}, status: 200
                else
                    render json: {}, status: 500
                end
            end
        else
            render json: {}, status: 404
        end
    end

    def familyIndex
        blm = Blm.find(params[:id])

        family = blm.relationships.where("relationship != 'Friend'").page(params[:page]).per(numberOfPage)
        if family.total_count == 0 || (family.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif family.total_count < numberOfPage
            itemsremaining = family.total_count 
        else
            itemsremaining = family.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {
            itemsremaining: itemsremaining,
            family: ActiveModel::SerializableResource.new(
                        family, 
                        each_serializer: RelationshipSerializer
                    )
        }
    end

    def friendsIndex
        blm = Blm.find(params[:id])

        friends = blm.relationships.where(relationship: 'Friend').page(params[:page]).per(numberOfPage)
        if friends.total_count == 0 || (friends.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif friends.total_count < numberOfPage
            itemsremaining = friends.total_count 
        else
            itemsremaining = friends.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {
            itemsremaining: itemsremaining,
            friends: ActiveModel::SerializableResource.new(
                        friends, 
                        each_serializer: RelationshipSerializer
                    )
        }
    end

    def followersIndex
        blmFollowersRaw = Follower.where(page_type: 'Blm', page_id: params[:id]).map{|follower| follower.account}

        blmFollowers = Kaminari.paginate_array(blmFollowersRaw).page(params[:page]).per(numberOfPage)
        if blmFollowers.total_count == 0 || (blmFollowers.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif blmFollowers.total_count < numberOfPage
            itemsremaining = blmFollowers.total_count 
        else
            itemsremaining = blmFollowers.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {
            itemsremaining: itemsremaining,
            followers: ActiveModel::SerializableResource.new(
                            blmFollowers, 
                            each_serializer: UserSerializer
                        )
        }
    end

    def adminIndex
        adminsRaw = Blm.find(params[:page_id]).roles.first.users.pluck('id')
        admins = Relationship.where(page_type: 'Blm', page_id: params[:page_id], account_type: 'User', account_id: adminsRaw)
        admins = admins.page(params[:page]).per(numberOfPage)

        if admins.total_count == 0 || (admins.total_count - (params[:page].to_i * numberOfPage)) < 0
            adminsitemsremaining = 0
        elsif admins.total_count < numberOfPage
            adminsitemsremaining = admins.total_count 
        else
            adminsitemsremaining = admins.total_count - (params[:page].to_i * numberOfPage)
        end
        
        familyRaw = Blm.find(params[:page_id]).relationships.where("relationship != 'Friend' AND account_type = 'User' AND account_id NOT IN (?)", adminsRaw)
        family = familyRaw.page(params[:page]).per(numberOfPage)

        if family.total_count == 0 || (family.total_count - (params[:page].to_i * numberOfPage)) < 0
            familyitemsremaining = 0
        elsif admins.total_count < numberOfPage
            familyitemsremaining = family.total_count 
        else
            familyitemsremaining = family.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {
            adminsitemsremaining: adminsitemsremaining,
            admins: ActiveModel::SerializableResource.new(
                        admins, 
                        each_serializer: RelationshipSerializer
                    ),
            familyitemsremaining: familyitemsremaining,
            family: ActiveModel::SerializableResource.new(
                        family, 
                        each_serializer: RelationshipSerializer
                    )
        }
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

    def verify_user_account_type
        if user().account_type == 2
            render json: {status: "Oops! Looks like your account is not registered as Black Lives Matter account. Register to continue."}
        end
    end

    def blm_params
        params.require(:blm).permit(:name, :description, :location, :precinct, :dob, :rip, :state, :country,  :backgroundImage, :profileImage, :longitude, :latitude, imagesOrVideos: [])
    end

    def blm_details_params
        params.permit(:name, :description, :location, :precinct, :dob, :rip, :state, :country, :longitude, :latitude)
    end

    def blm_images_params
        params.permit(:backgroundImage, :profileImage, imagesOrVideos: [])
    end

    def authorize
        blm = Blm.find(params[:id])

        if !user().has_role? :pageadmin, blm 
            return render json: {status: "Access Denied"}
        end
    end
    
end
