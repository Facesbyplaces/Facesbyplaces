class MemorialsController < ApplicationController
    
    def index
        render json: {id: user_id()}
    end

    def new
        @memorial = Memorial.new()
    end

    def create
        # create new memorial page
        memorial = Memorial.new(memorial_params)
        # check if memorial is saved properly
        if memorial.save 
            # add relationship of the current user (user that created the memorial page) to the relatioship table
            relationship = MemorialUserRelationship.new(
                                user_id: user_id(),
                                memorial: memorial,
                                relationship: params[:relationship]
                            )
            # check if relationship is saved properly
            if relationship.save 
                render json: {memorial: memorial}
            else
                render json: {status: 'Error saving relationship'}
            end
        else
            render json: {status: "Error saving memorial"}
        end
    end

    private
    def memorial_params
        params.require(:memorial).permit(:birthplace, :dob, :rip, :cemetery, :country, :name, :description)
    end

    def user_id
        1
    end
end
