class BlmController < ApplicationController

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
            # save blm
            blm.save 

            # save the owner of the user
            pageowner = Pageowner.new(user: user())
            blm.pageowner = pageowner

            # save relationship of the user to the page
            relationship = blm.relationships.new(user: user(), relationship: params[:relationship])
            relationship.save 
            
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
            blm.update(blm_details_params)

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

    private
    def blm_params
        params.require(:blm).permit(:name, :description, :location, :precinct, :dob, :rip, :state, :country,  :backgroundImage, :profileImage, imagesOrVideos: [])
    end

    def blm_details_params
        params.permit(:name, :description, :location, :precinct, :dob, :rip, :state, :country)
    end

    def blm_images_params
        params.permit(:backgroundImage, :profileImage, imagesOrVideos: [])
    end

    def params_presence(data)
        # list of optional parameters
        list = ['description', 'backgroundImage', 'imagesOrVideos', 'profileImage', 'precinct']
        data.each do |key, datum|
            if !list.include?(key)
                if datum == ""
                    return key
                end
            end
        end
        return true
    end
end
