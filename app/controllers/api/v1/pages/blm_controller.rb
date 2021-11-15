class Api::V1::Pages::BlmController < ApplicationController
    include Blmable
    before_action :authenticate_user, except: [:show]
    before_action :set_blm, except: [:create, :followersIndex, :adminIndex]
    before_action :verify_update_image_params, only: [:updateImages]
    before_action :verify_relationship, only: [:setRelationship]
    before_action :verify_user_account_type, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages, :create]
    before_action :verify_page_admin, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages]
    before_action :verify_create_params, only: [:create]
    before_action :verify_update_params, only: [:updateDetails]
    before_action :set_families, only: [:familyIndex]
    before_action :set_friends, only: [:friendsIndex]
    before_action :set_followers, only: [:followersIndex]
    before_action :set_adminsRaw, only: [:adminIndex, :delete]
    before_action :set_admins, only: [:adminIndex]
    before_action :set_family_admins, only: [:adminIndex]
    before_action :add_view_count, only: [:show]

    def create
        Memorials::Create.new( memorial: blm_params, user: user(), relationship: params[:relationship], type: "Blm" ).execute

        render json: { blm: { memorial: Blm.last, user: user(), relationship: params[:relationship] }, status: :created }
    end

    def delete
        Memorials::Destroy.new( memorial: @blm, admins: @adminsRaw, id: params[:id], type: "Blm" ).execute
        
        render json: {status: "deleted"}
    end

    def show
        render json: {blm: BlmSerializer.new( @blm ).attributes}
    end

    def editDetails
        render json: {blm: BlmSerializer.new( @blm ).attributes}
    end

    def editImages
        render json: {blm: BlmSerializer.new( @blm ).attributes}
    end

    def updateImages
        render json: {blm: BlmSerializer.new( @blm ).attributes, status: "updated images"} if @blm.update(blm_images_params)
    end

    def setPrivacy
        @blm.update(privacy: params[:privacy])
        render json: {status: :success}
    end

    def setRelationship   # for friends and families
        @blm.relationships.where(account: user()).first.update(relationship: params[:relationship])
        render json: {status: :success}
    end

    def updateDetails
        @blm.update(blm_details_params)
        @blm.relationships.where(account: user()).first.update(relationship: params[:relationship])

        render json: {blm: BlmSerializer.new( @blm ).attributes, status: "updated details"}
    end
    
    def leaveBLM        # leave blm page for family and friends
        return render json: {}, status: 404 unless @blm.relationships.where(account: user()).first != nil
        return render json: {}, status: 401 unless user().has_role? :pageadmin, @blm && User.with_role(:pageadmin, @blm).count != 1 && @blm.relationships.where(account: user()).first.destroy 
        
        user().remove_role :pageadmin, @blm
        render json: {}, status: 200
    end

    def familyIndex
        render json: {
            itemsremaining: itemsRemaining(@families),
            family: ActiveModel::SerializableResource.new(
                        @families, 
                        each_serializer: RelationshipSerializer
                    )
        }
    end

    def friendsIndex
        render json: {
            itemsremaining: itemsRemaining(@friends),
            friends: ActiveModel::SerializableResource.new(
                        @friends, 
                        each_serializer: RelationshipSerializer
                    )
        }
    end

    def followersIndex
        render json: {
            itemsremaining: itemsRemaining(@followers),
            followers: ActiveModel::SerializableResource.new(
                            @followers, 
                            each_serializer: UserSerializer
                        )
        }
    end

    def adminIndex
        render json: {
            adminsitemsremaining: itemsRemaining(@admins),
            admins: ActiveModel::SerializableResource.new(
                        @admins, 
                        each_serializer: RelationshipSerializer
                    ),
            familyitemsremaining: itemsRemaining(@family_admins),
            family: ActiveModel::SerializableResource.new(
                        @family_admins,
                        each_serializer: RelationshipSerializer
                    )
        }
    end

    private

    def verify_user_account_type
        return render json: {status: 404, message: "Oops! Looks like your account is not registered as Black Lives Matter account. Register to continue."} unless user().account_type == 1
    end

    def verify_page_admin
        return render json: {status: 401, message: "Access Denied"} if user().has_role? :pageadmin, @blm == false
    end

    def verify_create_params
        return render json: {status: 400, message: "Params is empty"} unless params_presence(blm_params) == true
    end

    def verify_update_params
        return render json: {status: 400, message: "Params is empty"} unless params_presence(blm_details_params) == true
    end

    def verify_update_image_params
        return render json: {status: 400, message: 'Error'} unless @blm.update(blm_images_params) == true
    end

    def verify_relationship
        return render json: {status: 400, message: "You're not part of the family or friends"} unless @blm.relationships.where(account: user()).first == true
    end

    def blm_params
        params.require(:blm).permit(:name, :description, :location, :rip, :state, :country, :backgroundImage, :profileImage, :longitude, :latitude, imagesOrVideos: [])
    end

    def blm_details_params
        params.permit(:name, :description, :location, :rip, :state, :country, :longitude, :latitude)
    end

    def blm_images_params
        params.permit(:backgroundImage, :profileImage, imagesOrVideos: [])
    end

end
