class Api::V1::Pages::MemorialsController < ApplicationController
    before_action :authenticate_user!, except: [:show]
    before_action :authorize, except: [:create, :show, :setRelationship]
    before_action :verify_user_account_type, except: [:show]

    def show
        memorial = Memorial.find(params[:id])
        
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

            # save memorial
            memorial.save
            
            # Tell the Mailer to send link to register stripe user account after save
            redirect_uri = Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :redirect_uri)
            client_id = Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :client_id)
            SendStripeLinkMailer.send_link(redirect_uri, client_id, current_user, memorial.id).deliver_now

            # save the owner of the user
            pageowner = Pageowner.new(user: user())
            memorial.pageowner = pageowner

            # save relationship of the user to the page
            relationship = memorial.relationships.new(user: user(), relationship: params[:relationship])
            relationship.save 

            # Make the user as admin of the 
            user().add_role "pageadmin", memorial

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

    private
    def verify_user_account_type
        if user.account_type == 1
            render json: {status: "Oops! Looks like your account is not registered as All Lives Matter account. Register to continue."}
        end
    end
    
    def memorial_params
        params.require(:memorial).permit(:name, :description, :birthplace, :dob, :rip, :cemetery, :country, :backgroundImage, :profileImage, imagesOrVideos: [])
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
