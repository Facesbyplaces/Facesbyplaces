class Api::V1::Pages::BlmController < ApplicationController
    before_action :authenticate_user!, except: [:show]
    before_action :authorize, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages, :create]
    before_action :verify_user_account_type, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages, :create]

    def show
        blm = Blm.find(params[:id])
        
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

            # save blm
            blm.save 

            # Tell the Mailer to send link to register stripe user account after save
            redirect_uri = Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :redirect_uri)
            client_id = Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :client_id)
            SendStripeLinkMailer.send_blm_link(redirect_uri, client_id, current_user, blm.id).deliver_now

            # save the owner of the user
            pageowner = Pageowner.new(user: user())
            blm.pageowner = pageowner

            # save relationship of the user to the page
            relationship = blm.relationships.new(user: user(), relationship: params[:relationship])
            relationship.save 

            # Make the user as admin of the 
            user().add_role "pageadmin", blm
            
            render json: {blm: BlmSerializer.new( blm ).attributes, status: :created}
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
            blm.relationships.where(user_id: user().id).first.update(relationship: params[:relationship])

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
        
        render json: {status: "deleted"}
    end

    def setPrivacy
        blm = Blm.find(params[:id])
        blm.update(privacy: params[:privacy])
        render json: {status: :success}
    end

    def setRelationship   # for friends and families
        blm = Blm.find(params[:id])

        if blm.relationships.where(user_id: user().id).first
            blm.relationships.where(user_id: user().id).first.update(relationship: params[:relationship])

            render json: {status: :success}
        else
            render json: {status: "You're not part of the family or friends"}
        end
    end

    def leaveBLM        # leave blm page for family and friends
        blm = Blm.find(params[:id])
        if blm.relationships.where(user: user()).first != nil
            # check if the user is a pageadmin
            if user().has_role? :pageadmin, blm
                if User.with_role(:pageadmin, blm).count != 1
                    # remove user from the page
                    if blm.relationships.where(user: user()).first.destroy 
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
                if blm.relationships.where(user: user()).first.destroy 
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
        blm = Blm.find(params[:id])

        followers = blm.users.page(params[:page]).per(numberOfPage)
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
        if user.account_type == 2
            render json: {status: "Oops! Looks like your account is not registered as Black Lives Matter account. Register to continue."}
        end
    end

    def blm_params
        params.require(:blm).permit(:name, :description, :location, :precinct, :dob, :rip, :state, :country,  :backgroundImage, :profileImage, :longitude, :latitude, imagesOrVideos: [])
    end

    def blm_details_params
        params.permit(:name, :description, :location, :precinct, :dob, :rip, :state, :country)
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
