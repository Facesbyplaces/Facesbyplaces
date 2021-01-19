class Api::V1::Pages::MemorialsController < ApplicationController
    before_action :check_user, except: [:show]
    before_action :authorize, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages]
    before_action :verify_user_account_type, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages, :create]

    def show
        memorial = Memorial.find(params[:id])
        
        # add count to view of page
        page = Pageowner.where(page_type: 'Memorial', page_id: memorial.id).first
        if page.view == nil
            page.update(view: 1)
        else
            page.update(view: (page.view + 1))
        end
        
        render json: {memorial: MemorialSerializer.new( memorial ).attributes}
    end

    def create
        # create new memorial page
        memorial = Memorial.new(memorial_params)

        # get user for sending links to their email.
        # @user = User.find(params[:user_id])

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
            pageowner = Pageowner.new(account_type:  "AlmUser", account_id: user().id, view: 0)
            memorial.pageowner = pageowner

            # save relationship of the user to the page
            relationship = memorial.relationships.new(account: user(), relationship: params[:relationship])
            relationship.save 

            # Make the user as admin of the 
            user().add_role "pageadmin", memorial
            
            # Tell the Mailer to send link to register stripe user account after save
            redirect_uri = Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :redirect_uri)
            client_id = Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :client_id)
            SendStripeLinkMailer.send_memorial_link(redirect_uri, client_id, user(), memorial.id).deliver_now

            render json: {memorial: MemorialSerializer.new( memorial ).attributes, status: :created}

            # Notify all Users
            blmUsers = User.joins(:notifsetting).where("notifsettings.newMemorial": true)
            almUsers = AlmUser.joins(:notifsetting).where("notifsettings.newMemorial": true).where("notifsettings.account_type != 'AlmUser' AND notifsettings.account_id != #{user().id}")

            blmUsers.each do |user|
                Notification.create(recipient: user, actor: user(), read: false, action: "#{user().first_name} created a new page", postId: memorial.id, notif_type: 'Memorial')
            end
            
            almUsers.each do |user|
                Notification.create(recipient: user, actor: user(), read: false, action: "#{user().first_name} created a new page", postId: memorial.id, notif_type: 'Memorial')
            end
        else
            render json: {status: "#{check} is empty"}
        end
    end

    def editDetails
        memorial = Memorial.find(params[:id])
        # render memorial details that be editted
        render json: {memorial: MemorialSerializer.new( memorial ).attributes}
    end

    def updateDetails
        memorial = Memorial.find(params[:id])
        
        # check if data sent is empty or not
        check = params_presence(params)
        if check == true
            # Update memorial details
            memorial.update(memorial_details_params)

            # Update relationship of the current page admin to the page
            memorial.relationships.where(account: user()).first.update(relationship: params[:relationship])

            return render json: {memorial: MemorialSerializer.new( memorial ).attributes, status: "updated details"}
        else
            return render json: {error: "#{check} is empty"}
        end
    end

    def editImages
        memorial = Memorial.find(params[:id])
        # render memorial images that be editted
        render json: {memorial: MemorialSerializer.new( memorial ).attributes}
    end

    def updateImages
        memorial = Memorial.find(params[:id])
        
        # check if memorial is updated successfully
        if memorial.update(memorial_images_params)
            return render json: {memorial: MemorialSerializer.new( memorial ).attributes, status: "updated images"}
        else
            return render json: {status: 'Error'}
        end
    end

    def delete
        memorial = Memorial.find(params[:id])
        memorial.destroy()

        user().remove_role :pageadmin, memorial
        
        render json: {status: "deleted"}
    end

    def setPrivacy
        memorial = Memorial.find(params[:id])
        memorial.update(privacy: params[:privacy])
        render json: {status: :success}
    end

    def setRelationship   # for friends and families
        memorial = Memorial.find(params[:id])

        if memorial.relationships.where(account: user()).first
            memorial.relationships.where(account: user()).first.update(relationship: params[:relationship])

            render json: {status: :success}
        else
            render json: {status: "You're not part of the family or friends"}
        end
    end

    def leaveMemorial       # leave memorial page for family and friends
        memorial = Memorial.find(params[:id])
        if memorial.relationships.where(account: user()).first != nil
            # check if the user is a pageadmin
            if user().has_role? :pageadmin, memorial
                if AlmUser.with_role(:pageadmin, memorial).count != 1
                    # remove user from the page
                    if memorial.relationships.where(account: user()).first.destroy 
                        # remove role as a page admin
                        user().remove_role :pageadmin, memorial
                        render json: {}, status: 200
                    else
                        render json: {}, status: 500
                    end
                else
                    render json: {}, status: 406
                end
            else
                # remove user from the page
                if memorial.relationships.where(account: user()).first.destroy 
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
        memorial = Memorial.find(params[:id])

        family = memorial.relationships.where("relationship != 'Friend'").page(params[:page]).per(numberOfPage)
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
        memorial = Memorial.find(params[:id])

        friends = memorial.relationships.where(relationship: 'Friend').page(params[:page]).per(numberOfPage)
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
        memorialFollowers = Follower.where(page_type: 'Memorial', page_id: params[:id]).map{|follower| follower.account}

        memorialFollowers = Kaminari.paginate_array(memorialFollowers).page(params[:page]).per(numberOfPage)
        if memorialFollowers.total_count == 0 || (memorialFollowers.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif memorialFollowers.total_count < numberOfPage
            itemsremaining = memorialFollowers.total_count 
        else
            itemsremaining = memorialFollowers.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {
            itemsremaining: itemsremaining,
            followers: ActiveModel::SerializableResource.new(
                            memorialFollowers, 
                            each_serializer: UserSerializer
                        )
        }
    end

    def adminIndex
        adminsRaw = AlmRole.where(resource_type: 'Memorial', resource_id: params[:page_id]).joins("INNER JOIN alm_users_alm_roles ON alm_roles.id = alm_users_alm_roles.alm_role_id").pluck("alm_users_alm_roles.alm_user_id")

        admins = Relationship.where(page_type: 'Memorial', page_id: params[:page_id], account_type: 'AlmUser', account_id: adminsRaw)
        admins = admins.page(params[:page]).per(numberOfPage)

        if admins.total_count == 0 || (admins.total_count - (params[:page].to_i * numberOfPage)) < 0
            adminsitemsremaining = 0
        elsif admins.total_count < numberOfPage
            adminsitemsremaining = admins.total_count 
        else
            adminsitemsremaining = admins.total_count - (params[:page].to_i * numberOfPage)
        end
        
        familyRaw = Memorial.find(params[:page_id]).relationships.where("relationship != 'Friend' AND account_type = 'AlmUser' AND account_id NOT IN (?)", adminsRaw)
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

    private
    def verify_user_account_type
        if user.account_type == 1
            render json: {status: "Oops! Looks like your account is not registered as All Lives Matter account. Register to continue."}
        end
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

    def authorize
        memorial = Memorial.find(params[:id])

        if !user().has_role? :pageadmin, memorial 
            return render json: {status: "Access Denied"}
        end
    end
end
