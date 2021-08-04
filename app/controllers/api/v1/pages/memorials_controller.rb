class Api::V1::Pages::MemorialsController < ApplicationController
    include Memorialable
    before_action :authenticate_user, except: [:show]
    before_action :set_memorial, except: [:create, :followersIndex, :adminIndex]
    before_action :verify_update_images_params, only: [:updateImages]
    before_action :verify_relationship, only: [:setRelationship]
    before_action :verify_user_account_type, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages, :create]
    before_action :verify_create_params, only: [:create]
    before_action :verify_update_params, only: [:updateDetails]
    before_action :verify_page_admin, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages]
    before_action :set_adminsRaw, only: [:adminIndex, :delete]
    before_action :set_families, only: [:familyIndex]
    before_action :set_friends, only: [:friendsIndex]
    before_action :set_followers, only: [:followersIndex]
    before_action :set_adminsRaw, only: [:adminIndex, :delete]
    before_action :set_admins, only: [:adminIndex]
    before_action :set_family_admins, only: [:adminIndex]
    
    def create
        memorial = Memorial.new(memorial_params)
        save_memorial(memorial)
    end

    def show
        add_view_count
        render json: {memorial: MemorialSerializer.new( @memorial ).attributes}
    end

    def editDetails
        render json: {memorial: MemorialSerializer.new( @memorial ).attributes}
    end

    def updateDetails
        @memorial.update(memorial_details_params)
        @memorial.relationships.where(account: user()).first.update(relationship: params[:relationship])

        return render json: {memorial: MemorialSerializer.new( @memorial ).attributes, status: "updated details"}
    end

    def editImages
        render json: {memorial: MemorialSerializer.new( @memorial ).attributes}
    end

    def updateImages
        render json: {memorial: MemorialSerializer.new( @memorial ).attributes, status: "updated images"}
    end

    def delete
        @adminsRaw.each do |admin_id|
            AlmUser.find(admin_id).roles.where(resource_type: 'Memorial', resource_id: params[:id]).first.destroy 
        end
        @memorial.destroy()
        
        render json: {status: "deleted"}
    end

    def setPrivacy
        @memorial.update(privacy: params[:privacy])
        render json: {status: :success}
    end

    def setRelationship   # for friends and families
        @memorial.relationships.where(account: user()).first.update(relationship: params[:relationship])
        render json: {status: :success}
    end

    def leaveMemorial       # leave memorial page for family and friends-]
        return render json: {}, status: 404 unless @memorial.relationships.where(account: user()).first != nil
        
        if user().has_role? :pageadmin, @memorial && AlmUser.with_role(:pageadmin, @memorial).count != 1 && @memorial.relationships.where(account: user()).first.destroy 
            user().remove_role :pageadmin, @memorial
            render json: {}, status: 200
        elsif @memorial.relationships.where(account: user()).first.destroy 
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
        return render json: {status: "Oops! Looks like your account is not registered as All Lives Matter account. Register to continue."} unless user.account_type == 2
    end

    def verify_create_params
        return render json: {error: "#{check} is empty"} unless params_presence(memorial_params) == true
    end

    def verify_update_params
        return render json: {error: "#{check} is empty"} unless params_presence(memorial_details_params) == true
    end

    def verify_update_images_params
        return render json: {error: "#{check} is empty"} unless params_presence(memorial_images_params) == true
    end

    def verify_relationship
        return render json: {status: "You're not part of the family or friends"} unless @memorial.relationships.where(account: user()).first.update(relationship: params[:relationship]) == true
    end

    def verify_page_admin
        return render json: {status: "Access Denied"} if user().has_role? :pageadmin, @memorial == false
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
