class MemorialsController < ApplicationController
    
    def index
        memorials = Memorial.all()
        paginate memorials, per_page: numberOfPage
    end

    def show
        memorial = Memorial.find(memorial_id)
        relationship = memorial.memorialUserRelationships.where(user_id: user_id).first.relationship
        render json: memorial
    end

    def new
        @memorial = Memorial.new()
    end

    def create
        # create new memorial page
        memorial = Memorial.new(memorial_params)
        # check if the params sent is valid or not
        check = params_presence(params[:memorial])
        if check == true
            # save memorial
            memorial.save 
            # add relationship of the current user (user that created the memorial page) to the relatioship table
            relationship = MemorialUserRelationship.new(
                                user_id: user_id(),
                                memorial: memorial,
                                relationship: params[:relationship]
                            )
            # check if relationship is saved properly
            if relationship.save 
                render json: memorial, status: :created
            else
                render json: {status: 'Error saving relationship'}
            end
        else
            render json: {status: "#{check} is empty"}
        end
    end

    def editDetails
        memorial = Memorial.find(memorial_id)
        # render memorial details that be editted
        render json: memorial
    end

    def updateDetails
        memorial = Memorial.find(memorial_id)
        
        # check if data sent is empty or not
        check = params_presence(params)
        if check == true
            memorial.update(memorial_details_params)

            redirect_to memorialShow_path(memorial.id)
        else
            return render json: {error: "#{check} is empty"}
        end
    end

    def editImages
        memorial = Memorial.find(memorial_id)
        # render memorial images that be editted
        render json: memorial
    end

    def updateImages
        memorial = Memorial.find(memorial_id)
        
        # check if memorial is updated successfully
        if memorial.update(memorial_images_params)
            redirect_to memorialShow_path(memorial.id)
        else
            return render json: {status: 'Error'}
        end
    end

    def delete
        memorial = Memorial.find(memorial_id)
        memorial.destroy()
        
        render json: {status: "deleted"}
    end

    private
    def memorial_params
        params.require(:memorial).permit(:birthplace, :dob, :rip, :cemetery, :country, :name, :description, :backgroundImage, :profileImage, imagesOrVideos: [])
    end

    def user_id
        1
    end

    def memorial_id
        params[:id]
    end

    def memorial_details_params
        params.permit(:birthplace, :dob, :rip, :cemetery, :country, :name, :description)
    end

    def memorial_images_params
        params.permit(:backgroundImage, :profileImage, imagesOrVideos: [])
    end

    def params_presence(data)
        list = ['description', 'backgroundImage', 'imagesOrVideos', 'profileImage']
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
