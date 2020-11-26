class Api::V1::Pages::BlmController < ApplicationController
    before_action :authenticate_user!, except: [:show]
    before_action :authorize, except: [:create, :show, :setRelationship]
    before_action :verify_user_account_type, except: [:show]

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

    private

    def verify_user_account_type
        if user.account_type == 2
            render json: {status: "Oops! Looks like your account is not registered as Black Lives Matter account. Register to continue."}
        end
    end

    def blm_params
        params.require(:blm).permit(:name, :description, :location, :precinct, :dob, :rip, :state, :country,  :backgroundImage, :profileImage, imagesOrVideos: [])
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
