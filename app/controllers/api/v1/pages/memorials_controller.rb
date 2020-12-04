class Api::V1::Pages::MemorialsController < ApplicationController
    before_action :authenticate_user!, except: [:show]
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
            pageowner = Pageowner.new(user: user(), view: 0)
            memorial.pageowner = pageowner

            # save relationship of the user to the page
            relationship = memorial.relationships.new(user: user(), relationship: params[:relationship])
            relationship.save 

            # Make the user as admin of the 
            user().add_role "pageadmin", memorial
            
            # Tell the Mailer to send link to register stripe user account after save
            redirect_uri = Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :redirect_uri)
            client_id = Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :client_id)
            SendStripeLinkMailer.send_memorial_link(redirect_uri, client_id, current_user, memorial.id).deliver_now

            render json: {memorial: MemorialSerializer.new( memorial ).attributes, status: :created}
        else
            render json: {status: "#{check} is empty"}
        end
    end

    def editDetails
        memorial = Memorial.find(params[:id])
        # render memorial details that be editted
        render json: memorial
    end

    def updateDetails
        memorial = Memorial.find(params[:id])
        
        # check if data sent is empty or not
        check = params_presence(params)
        if check == true
            # Update memorial details
            memorial.update(memorial_details_params)

            # Update relationship of the current page admin to the page
            memorial.relationships.where(user_id: user().id).first.update(relationship: params[:relationship])

            return render json: {memorial: MemorialSerializer.new( memorial ).attributes, status: "updated details"}
        else
            return render json: {error: "#{check} is empty"}
        end
    end

    def editImages
        memorial = Memorial.find(params[:id])
        # render memorial images that be editted
        render json: memorial
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
        
        render json: {status: "deleted"}
    end

    def setPrivacy
        memorial = Memorial.find(params[:id])
        memorial.update(privacy: params[:privacy])
        render json: {status: :success}
    end

    def setRelationship   # for friends and families
        memorial = Memorial.find(params[:id])

        if memorial.relationships.where(user_id: user().id).first
            memorial.relationships.where(user_id: user().id).first.update(relationship: params[:relationship])

            render json: {status: :success}
        else
            render json: {status: "You're not part of the family or friends"}
        end
    end

    def leaveMemorial       # leave memorial page for family and friends
        memorial = Memorial.find(params[:id])
        if memorial.relationships.where(user: user()).first != nil
            # check if the user is a pageadmin
            if user().has_role? :pageadmin, memorial
                if User.with_role(:pageadmin, memorial).count != 1
                    # remove user from the page
                    if memorial.relationships.where(user: user()).first.destroy 
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
                if memorial.relationships.where(user: user()).first.destroy 
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
        memorial = Memorial.find(params[:id])

        followers = memorial.users.page(params[:page]).per(numberOfPage)
        if followers.total_count == 0 || (followers.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif followers.total_count < numberOfPage
            itemsremaining = followers.total_count 
        else
            itemsremaining = followers.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {
            itemsremaining: itemsremaining,
            followers: followers
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
        params.permit(:birthplace, :dob, :rip, :cemetery, :country, :name, :description)
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
