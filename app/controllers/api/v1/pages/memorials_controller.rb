class Api::V1::Pages::MemorialsController < ApplicationController
    before_action :authenticate_user, except: [:show]
    before_action :verify_user_account_type, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages, :create]
    before_action :set_memorial, except: [:create, :followersIndex, :familyIndex, :adminIndex]
    before_action :authorize, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages]

    def create
        # create new memorial page
        memorial = Memorial.new(memorial_params)

        if valid_params(params[:memorial]) == true
            # save memorial
            save_memorial(memorial)
        else
            render json: {status: "#{check} is empty"}
        end
    end

    def show
        # add count to view of page
        add_view_count
        
        render json: {memorial: MemorialSerializer.new( @memorial ).attributes}
    end

    def editDetails
        # render memorial details that can be edited
        render json: {memorial: MemorialSerializer.new( @memorial ).attributes}
    end

    def updateDetails
        if valid_params(params) == true
            # Update memorial details
            @memorial.update(memorial_details_params)

            # Update relationship of the current page admin to the page
            @memorial.relationships.where(account: user()).first.update(relationship: params[:relationship])

            return render json: {memorial: MemorialSerializer.new( @memorial ).attributes, status: "updated details"}
        else
            return render json: {error: "#{check} is empty"}
        end
    end

    def editImages
        # render memorial images that be editted
        render json: {memorial: MemorialSerializer.new( @memorial ).attributes}
    end

    def updateImages
        # check if memorial is updated successfully
        if @memorial.update(memorial_images_params)
            return render json: {memorial: MemorialSerializer.new( @memorial ).attributes, status: "updated images"}
        else
            return render json: {status: 'Error'}
        end
    end

    def delete
        @memorial.destroy()

        adminsRaw = AlmRole.where(resource_type: 'Memorial', resource_id: params[:id]).joins("INNER JOIN alm_users_alm_roles ON alm_roles.id = alm_users_alm_roles.alm_role_id").pluck("alm_users_alm_roles.alm_user_id")
        
        adminsRaw.each do |admin_id|
            AlmUser.find(admin_id).roles.where(resource_type: 'Memorial', resource_id: params[:id]).first.destroy 
        end
        
        render json: {status: "deleted"}
    end

    def setPrivacy
        @memorial.update(privacy: params[:privacy])

        render json: {status: :success}
    end

    def setRelationship   # for friends and families
        if @memorial.relationships.where(account: user()).first
            @memorial.relationships.where(account: user()).first.update(relationship: params[:relationship])

            render json: {status: :success}
        else
            render json: {status: "You're not part of the family or friends"}
        end
    end

    def leaveMemorial       # leave memorial page for family and friends
        if @memorial.relationships.where(account: user()).first != nil
            # check if the user is a pageadmin
            if user().has_role? :pageadmin, @memorial
                if AlmUser.with_role(:pageadmin, @memorial).count != 1
                    # remove user from the page
                    if @memorial.relationships.where(account: user()).first.destroy 
                        # remove role as a page admin
                        user().remove_role :pageadmin, @memorial
                        render json: {}, status: 200
                    else
                        render json: {}, status: 500
                    end
                else
                    render json: {}, status: 406
                end
            else
                # remove user from the page
                if @memorial.relationships.where(account: user()).first.destroy 
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
        family = @memorial.relationships.where("relationship != 'Friend'").page(params[:page]).per(numberOfPage)

        render json: {
            itemsremaining: itemsRemaining(family),
            family: ActiveModel::SerializableResource.new(
                        family, 
                        each_serializer: RelationshipSerializer
                    )
        }
    end

    def friendsIndex
        friends = @memorial.relationships.where(relationship: 'Friend').page(params[:page]).per(numberOfPage)
        
        render json: {
            itemsremaining: itemsRemaining(friends),
            friends: ActiveModel::SerializableResource.new(
                        friends, 
                        each_serializer: RelationshipSerializer
                    )
        }
    end

    def followersIndex
        memorialFollowers = Follower.where(page_type: 'Memorial', page_id: params[:id]).map{|follower| follower.account}
        memorialFollowers = Kaminari.paginate_array(memorialFollowers).page(params[:page]).per(numberOfPage)

        render json: {
            itemsremaining: itemsRemaining(memorialFollowers),
            followers: ActiveModel::SerializableResource.new(
                            memorialFollowers, 
                            each_serializer: UserSerializer
                        )
        }
    end

    def adminIndex
        adminsRaw = AlmRole.where(resource_type: 'Memorial', resource_id: params[:page_id]).joins("INNER JOIN alm_users_alm_roles ON alm_roles.id = alm_users_alm_roles.alm_role_id").pluck("alm_users_alm_roles.alm_user_id")
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
        if user.account_type == 1
            render json: {status: "Oops! Looks like your account is not registered as All Lives Matter account. Register to continue."}
        end
    end

    def authorize
        memorial = Memorial.find(params[:id])

        if !user().has_role? :pageadmin, memorial 
            return render json: {status: "Access Denied"}
        end
    end

    def set_memorial
        @memorial = Memorial.find(params[:id])
    end

    def memorial_params
        params.require(:memorial).permit(:name, :description, :birthplace, :dob, :rip, :cemetery, :country, :backgroundImage, :profileImage, :longitude, :latitude, imagesOrVideos: [])
    end

    def memorial_details_params
        params.permit(:birthplace, :dob, :rip, :cemetery, :country, :name, :description, :longitude, :latitude)
    end

    def memorial_images_params
        params.permit(:backgroundImage, :profileImage, imagesOrVideos: [])
    end

    def valid_params(params)
        return params_presence(params)
    end

    def save_memorial(memorial)
            set_privacy(memorial)

            if memorial.save
                # save the user as owner
                save_owner(memorial)
                # update memorial location
                update_location(memorial)
                # save relationship of the user to the page
                save_relationship(memorial)
            else  
                render json: {errors: memorial.errors}, status: 500
                memorial.destroy
            end
    end

    def set_privacy(memorial)
        # set privacy to public
        memorial.privacy = "public"
        memorial.hideFamily = false
        memorial.hideFriends = false
        memorial.hideFollowers = false
    end

    def save_owner(memorial)
        pageowner = Pageowner.new(account_type:  "AlmUser", account_id: user().id, view: 0)
        memorial.pageowner = pageowner
    end

    def update_location(memorial)
        memorial.update(latitude: memorial_params[:latitude], longitude: memorial_params[:longitude])
    end

    def save_relationship(memorial)
        # save relationship of the user to the page
        relationship = memorial.relationships.new(account: user(), relationship: params[:relationship])
        if relationship.save 
            # set current user as admin
            set_admin(memorial)
            # notify all Users
            notify_users(memorial)

            return render json: {memorial: MemorialSerializer.new( memorial ).attributes, status: :created}
        else
            return render json: {errors: relationship.errors}, status: 500
        end
    end

    def set_admin(memorial)
        user().add_role "pageadmin", memorial
    end

    def notify_users(memorial)
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
    end

    def add_view_count
        page = Pageowner.where(page_type: 'Memorial', page_id: @memorial.id).first

        if page == nil
            return render json: {errors: "Page not found"}, status: 400
        end
        
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
        admins = Relationship.where(page_type: 'Memorial', page_id: params[:page_id], account_type: 'AlmUser', account_id: adminsRaw)
        return admins = admins.page(params[:page]).per(numberOfPage)
    end

    def family_index(adminsRaw)
        familyRaw = Memorial.find(params[:page_id]).relationships.where("relationship != 'Friend' AND account_type = 'AlmUser' AND account_id NOT IN (?)", adminsRaw)
        return family = familyRaw.page(params[:page]).per(numberOfPage)
    end
    
end