class Api::V1::Pages::MemorialsController < ApplicationController
    before_action :authorize, except: [:create, :show]
    before_action :authenticate_user!

    def show
        memorial = Memorial.find(params[:id])
        
        render json: {memorial: MemorialSerializer.new( memorial ).attributes}
    end

    def create
        # create new memorial page
        memorial = Memorial.new(memorial_params)
        # check if the params sent is valid or not
        check = params_presence(params[:memorial])
        if check == true
            # save memorial
            memorial.save 

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
            memorial.update(memorial_details_params)

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

    private
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
