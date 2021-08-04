class Api::V1::Pages::BlmController < ApplicationController
    include Blmable
    before_action :authenticate_user, except: [:show]
    before_action :set_blm, except: [:create, :followersIndex, :adminIndex]
    before_action :verify_update_image_params, only: [:updateImages]
    before_action :verify_relationship, only: [:setRelationship]
    before_action :verify_user_account_type, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages, :create]
    before_action :verify_page_admin, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages]
    before_action :verify_create_params, only: [:create]
    before_action :verify_update_params, only: [:updateDetails]
    before_action :set_families, only: [:familyIndex]
    before_action :set_friends, only: [:friendsIndex]
    before_action :set_followers, only: [:followersIndex]
    before_action :set_adminsRaw, only: [:adminIndex, :delete]
    before_action :set_admins, only: [:adminIndex]
    before_action :set_family_admins, only: [:adminIndex]

    def create
        blm = Blm.new(blm_params)
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
        @blm.update(blm_details_params)
        @blm.relationships.where(account: user()).first.update(relationship: params[:relationship])

        render json: {blm: BlmSerializer.new( @blm ).attributes, status: "updated details"}
    end

    def editImages
        # render memorial images that be editted
        render json: {blm: BlmSerializer.new( @blm ).attributes}
    end

    def updateImages
        return render json: {blm: BlmSerializer.new( @blm ).attributes, status: "updated images"}
    end

    def delete
        @adminsRaw.each do |admin_id|
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
        @blm.relationships.where(account: user()).first.update(relationship: params[:relationship])
        render json: {status: :success}
    end

    def leaveBLM        # leave blm page for family and friends
        return render json: {}, status: 404 unless @blm.relationships.where(account: user()).first != nil
        
        # check if the user is a pageadmin
        if user().has_role? :pageadmin, @blm && User.with_role(:pageadmin, @blm).count != 1 && @blm.relationships.where(account: user()).first.destroy 
            user().remove_role :pageadmin, @blm
        elsif @blm.relationships.where(account: user()).first.destroy 
            render json: {}, status: 200
        else
            render json: {}, status: 401
        end
    end

    def familyIndex
        render json: {
            itemsremaining: itemsRemaining(@families),
            family: ActiveModel::SerializableResource.new(
                        @families, 
                        each_serializer: RelationshipSerializer
                    )
        }
    end

    def friendsIndex
        render json: {
            itemsremaining: itemsRemaining(@friends),
            friends: ActiveModel::SerializableResource.new(
                        @friends, 
                        each_serializer: RelationshipSerializer
                    )
        }
    end

    def followersIndex
        render json: {
            itemsremaining: itemsRemaining(@followers),
            followers: ActiveModel::SerializableResource.new(
                            @followers, 
                            each_serializer: UserSerializer
                        )
        }
    end

    def adminIndex
        render json: {
            adminsitemsremaining: itemsRemaining(@admins),
            admins: ActiveModel::SerializableResource.new(
                        @admins, 
                        each_serializer: RelationshipSerializer
                    ),
            familyitemsremaining: itemsRemaining(@family_admins),
            family: ActiveModel::SerializableResource.new(
                        @family_admins,
                        each_serializer: RelationshipSerializer
                    )
        }
    end

    private

    def verify_user_account_type
        return render json: {status: "Oops! Looks like your account is not registered as Black Lives Matter account. Register to continue."} unless user().account_type == 1
    end

    def verify_page_admin
        return render json: {status: "Access Denied"} if user().has_role? :pageadmin, @blm == false
    end

    def verify_create_params
        return render json: {status: "Params is empty"} unless params_presence(blm_params) == true
    end

    def verify_update_params
        return render json: {status: "Params is empty"} unless params_presence(blm_details_params) == true
    end

    def verify_update_image_params
        return render json: {status: 'Error'} unless @blm.update(blm_images_params) == true
    end

    def verify_relationship
        return render json: {status: "You're not part of the family or friends"} unless @blm.relationships.where(account: user()).first == true
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
end
