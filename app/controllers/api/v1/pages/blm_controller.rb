class Api::V1::Pages::BlmController < ApplicationController
    include Blmable
    before_action :authenticate_user, except: [:show]
    before_action :verify_user_account_type, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages, :create]
    before_action :set_blm, except: [:create, :followersIndex, :adminIndex]
    before_action :authorize, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages]

    def create
        # create new blm page
        blm = Blm.new(blm_params)
        return render json: {status: "#{valid_params} is empty"} unless valid_params(params[:blm]) == true
        
        # save blm
        save_blm(blm)
    end

    def show
        # add count to view of page
        add_view_count

        render json: {blm: BlmSerializer.new( @blm ).attributes}
    end

    def editDetails
        # render memorial details that be editted
        render json: {blm: BlmSerializer.new( @blm ).attributes}
    end

    def updateDetails
        return render json: {error: "#{valid_params} is empty"} unless valid_params(params) == true
        # Update blm details
        @blm.update(blm_details_params)
        # Update relationship of the current page admin to the page
        @blm.relationships.where(account: user()).first.update(relationship: params[:relationship])

        render json: {blm: BlmSerializer.new( @blm ).attributes, status: "updated details"}
    end

    def editImages
        # render memorial images that be editted
        render json: {blm: BlmSerializer.new( @blm ).attributes}
    end

    def updateImages
        return render json: {status: 'Error'} unless @blm.update(blm_images_params)
        render json: {blm: BlmSerializer.new( @blm ).attributes, status: "updated images"}
    end

    def delete
        adminsRaw = Blm.find(params[:page_id]).roles.first.users.pluck('id')
        adminsRaw.each do |admin_id|
            User.find(admin_id).roles.where(resource_type: 'Blm', resource_id: params[:id]).first.destroy 
        end

        @blm.destroy()
        
        render json: {status: "deleted"}
    end

    def setPrivacy
        @blm.update(privacy: params[:privacy])
        
        render json: {status: :success}
    end

    def setRelationship   # for friends and families
        return render json: {status: "You're not part of the family or friends"} unless @blm.relationships.where(account: user()).first
        
        @blm.relationships.where(account: user()).first.update(relationship: params[:relationship])
        render json: {status: :success}
    end

    def leaveBLM        # leave blm page for family and friends
        return render json: {}, status: 404 unless @blm.relationships.where(account: user()).first != nil
        
        # check if the user is a pageadmin
        if user().has_role? :pageadmin, @blm
            if User.with_role(:pageadmin, @blm).count != 1 && @blm.relationships.where(account: user()).first.destroy 
                # remove role as a page admin
                user().remove_role :pageadmin, @blm
            else
                render json: {}, status: 401
            end
        else
            # remove user from the page
            if @blm.relationships.where(account: user()).first.destroy 
                render json: {}, status: 200
            else
                render json: {}, status: 401
            end
        end
    end

    def familyIndex
        family = @blm.relationships.where("relationship != 'Friend'").page(params[:page]).per(numberOfPage)

        render json: {
            itemsremaining: itemsRemaining(family),
            family: ActiveModel::SerializableResource.new(
                        family, 
                        each_serializer: RelationshipSerializer
                    )
        }
    end

    def friendsIndex
        friends = @blm.relationships.where(relationship: 'Friend').page(params[:page]).per(numberOfPage)

        render json: {
            itemsremaining: itemsRemaining(friends),
            friends: ActiveModel::SerializableResource.new(
                        friends, 
                        each_serializer: RelationshipSerializer
                    )
        }
    end

    def followersIndex
        blmFollowersRaw = Follower.where(page_type: 'Blm', page_id: params[:id]).map{|follower| follower.account}
        blmFollowers = Kaminari.paginate_array(blmFollowersRaw).page(params[:page]).per(numberOfPage)

        render json: {
            itemsremaining: itemsRemaining(blmFollowers),
            followers: ActiveModel::SerializableResource.new(
                            blmFollowers, 
                            each_serializer: UserSerializer
                        )
        }
    end

    def adminIndex
        adminsRaw = Blm.find(params[:page_id]).roles.first.users.pluck('id')
        @admins = admins_index(adminsRaw)
        @family = family_index(adminsRaw)

        render json: {
            adminsitemsremaining: itemsRemaining(@admins),
            admins: ActiveModel::SerializableResource.new(
                        @admins, 
                        each_serializer: RelationshipSerializer
                    ),
            familyitemsremaining: itemsRemaining(@family),
            family: ActiveModel::SerializableResource.new(
                        @family,
                        each_serializer: RelationshipSerializer
                    )
        }
    end

    private

    def verify_user_account_type
        return render json: {status: "Oops! Looks like your account is not registered as Black Lives Matter account. Register to continue."} unless user().account_type == 1
    end

    def authorize
        return render json: {status: "Access Denied"} unless user().has_role? :pageadmin, @blm == true
    end

    def valid_params(params)
        return params_presence(params)
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

    def save_blm(blm)
        # set privacy to public
        set_privacy(blm)

        if blm.save
            # save the user as owner
            save_owner(blm)
            # update blm location
            update_location(blm)
            # save relationship of the user to the page
            save_relationship(blm)
        else  
            render json: {errors: blm.errors}, status: 500
            blm.destroy
        end
    end

    def set_privacy(blm)
        blm.privacy = "public"
        blm.hideFamily = false
        blm.hideFriends = false
        blm.hideFollowers = false
    end

    def save_owner(blm)
        pageowner = Pageowner.new(account_type: "User", account_id: user().id, view: 0)
        blm.pageowner = pageowner
    end

    def update_location(blm)
        blm.update(latitude: blm_params[:latitude], longitude: blm_params[:longitude])
    end

    def save_relationship(blm)
        relationship = blm.relationships.new(account: user(), relationship: params[:relationship])
        
        if relationship.save 
            # set current user as admin
            set_admin(blm)
            # notify all Users
            notify_users(blm)
            return render json: {blm: BlmSerializer.new( blm ).attributes, status: :created}
        else
            return render json: {errors: relationship.errors}, status: 500
        end
    end

    def set_admin(blm)
        user().add_role "pageadmin", blm
    end

    def notify_users(blm)
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
    end

    def add_view_count
        page = Pageowner.where(page_type: 'Blm', page_id: @blm.id).first
        return render json: {errors: "Page not found"}, status: 400 unless page != nil
        
        if page.view == nil
            page.update(view: 1)
        else
            page.update(view: (page.view + 1))
        end
    end

    def itemsRemaining(item)
        if item.total_count == 0 || (item.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif item.total_count < numberOfPage
            itemsremaining = item.total_count 
        else
            itemsremaining = item.total_count - (params[:page].to_i * numberOfPage)
        end
    end
    
    def admins_index(adminsRaw)
        admins = Relationship.where(page_type: 'Blm', page_id: params[:page_id], account_type: 'User', account_id: adminsRaw)
        return admins = admins.page(params[:page]).per(numberOfPage)
    end

    def family_index(adminsRaw)
        familyRaw = Blm.find(params[:page_id]).relationships.where("relationship != 'Friend' AND account_type = 'User' AND account_id NOT IN (?)", adminsRaw)
        return family = familyRaw.page(params[:page]).per(numberOfPage)
    end
end
