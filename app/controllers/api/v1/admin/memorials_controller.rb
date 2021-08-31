class Api::V1::Admin::MemorialsController < ApplicationController
    include Memorialable
    before_action :verify_admin
    before_action :set_users, only: [:usersSelection]    
    before_action :set_memorials, only: [:allMemorials]
    before_action :set_blms, only: [:allMemorials]
    before_action :set_adminsRaw, only: [:deleteMemorial]
    before_action :set_search_memorials, only: [:searchMemorial]
    before_action :set_memorial, only: [:showMemorial, :updateMemorial, :updateMemorialImages, :updateBlm, :updateBlmImages, :deleteMemorial]
    before_action :set_user, only: [:createMemorial]
    before_action :set_notif_type, only: [:createMemorial]
    # Memorial
    def usersSelection #for create memorial users selection
        render json: {success: true,  users: @users }, status: 200
    end

    def allMemorials
        render json: {
            itemsremaining:  itemsRemaining(@blm_memorials),
            memorials: {
                blm: @blms,
                alm: @memorials
            }
        }
    end
    
    def searchMemorial
        render json: {  itemsremaining:  itemsRemaining(@memorials),
                        memorials: @searched_memorials,
                        page_type: @page_type,
                    }
    end
    
    def createMemorial
        #IF MEMORIAL IS OF TYPE ALM
        if params[:page_type].to_i == 2
            Memorials::Create.new( memorial: memorial_params, user: @user, relationship: params[:relationship], type: "Memorial" ).execute

            render json: { memorial: Memorial.last, user: @user, relationship: params[:relationship], status: :created }
        #IF MEMORIAL IS OF TYPE BLM    
        elsif params[:page_type].to_i == 1
            Memorials::Create.new( memorial: blm_params, user: @user, relationship: params[:relationship], type: "Blm" ).execute

            render json: { memorial: Blm.last, user: @user, relationship: params[:relationship], status: :created }
        end
    end
    
    def showMemorial
        return render json: {errors: "Page not found"}, status: 404 unless @memorial
        render json: @memorial
    end
    
    def updateMemorial
        return render json: {error: "Params is empty"} unless params_presence(memorial_details_params) == true
        @memorial.update(memorial_details_params)
        # Update relationship of the current page admin to the page
        # memorial.relationships.where(account: user).first.update(relationship: params[:relationship])
        return render json: {memorial: MemorialSerializer.new( @memorial ).attributes, status: "updated details"}
    end
    
    def updateMemorialImages
        return render json: {status: 'Error'} unless @memorial.update(memorial_images_params)
        render json: {memorial: MemorialSerializer.new( @memorial ).attributes, status: "updated images"}
    end

    def updateBlm
        return render json: {error: "Params is empty"} unless params_presence(blm_details_params) == true
        @memorial.update(blm_details_params)
        # Update relationship of the current page admin to the page
        # blm.relationships.where(account: user()).first.update(relationship: params[:relationship])
        render json: {blm: BlmSerializer.new( @memorial ).attributes, status: "updated details"}
    end

    def updateBlmImages
        return render json: {status: 'Error'} unless @memorial.update(blm_images_params)
        render json: {blm: BlmSerializer.new( @memorial ).attributes, status: "updated images"}
    end  
    
    def deleteMemorial
        if params[:page] === "Memorial"
            Memorials::Destroy.new( memorial: @memorial, admins: @adminsRaw, id: params[:id], type: params[:page] ).execute
            
            render json: {status: "deleted"}
        elsif params[:page] === "Blm"
            Memorials::Destroy.new( memorial: @memorial, admins: @adminsRaw, id: params[:id], type: params[:page] ).execute
            
            render json: {status: "deleted"}
        end
    end

    private
    def verify_admin
        return render json: {status: "Must be an admin to continue"}, status: 401 unless user().has_role? :admin 
    end

    def memorial_params
        params.require(:memorial).permit(:name, :description, :birthplace, :dob, :rip, :cemetery, :country, :backgroundImage, :profileImage, :longitude, :latitude, imagesOrVideos: [])
    end

    def memorial_images_params
        params.permit(:backgroundImage, :profileImage, imagesOrVideos: [])
    end

    def blm_params
        params.require(:blm).permit(:name, :description, :location, :precinct, :dob, :rip, :state, :country,  :backgroundImage, :profileImage, :longitude, :latitude, imagesOrVideos: [])
    end

    def blm_images_params
        params.permit(:backgroundImage, :profileImage, imagesOrVideos: [])
    end

    def memorial_details_params
        params.permit(:birthplace, :dob, :rip, :cemetery, :country, :name, :description, :longitude, :latitude)
    end

    def blm_details_params
        params.permit(:name, :description, :location, :precinct, :dob, :rip, :state, :country, :longitude, :latitude)
    end

end
