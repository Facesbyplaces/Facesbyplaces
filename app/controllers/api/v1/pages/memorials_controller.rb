class Api::V1::Pages::MemorialsController < ApplicationController
    include Almable
    before_action :authenticate_user, except: [:show]
    before_action :set_memorial, except: [:create, :followersIndex, :adminIndex]
    before_action :verify_update_images_params, only: [:updateImages]
    before_action :verify_relationship, only: [:setRelationship]
    before_action :verify_user_account_type, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages, :create]
    before_action :verify_create_params, only: [:create]
    before_action :verify_update_params, only: [:updateDetails]
    before_action :verify_page_admin, only: [:editDetails, :updateDetails, :editImages, :delete, :setPrivacy, :updateImages]
    before_action :set_families, only: [:familyIndex]
    before_action :set_friends, only: [:friendsIndex]
    before_action :set_followers, only: [:followersIndex]
    before_action :set_adminsRaw, only: [:adminIndex, :delete]
    before_action :set_admins, only: [:adminIndex]
    before_action :set_family_admins, only: [:adminIndex]
    before_action :add_view_count, only: [:show]
    
    def create
        Memorials::Create.new( memorial: memorial_params, user: user(), relationship: params[:relationship], type: "Memorial" ).execute

        render json: { alm: { memorial: Memorial.last, user: user(), relationship: params[:relationship] }, status: :created }
    end

    def delete
        Memorials::Destroy.new( memorial: @memorial, admins: @adminsRaw, id: params[:id], type: "Memorial" ).execute
        
        render json: {status: "deleted"}
    end

    def show
        render json: {memorial: MemorialSerializer.new( @memorial ).attributes}
    end

    def editDetails
        render json: {memorial: MemorialSerializer.new( @memorial ).attributes}
    end

    def editImages
        render json: {memorial: MemorialSerializer.new( @memorial ).attributes}
    end

    def updateImages
        render json: {memorial: MemorialSerializer.new( @memorial ).attributes, status: "updated images"} if @memorial.update(memorial_images_params)
    end

    def setPrivacy
        @memorial.update(privacy: params[:privacy])
        render json: {status: :success}
    end

    def setRelationship   
        # for friends and families
        @memorial.relationships.where(account: user()).first.update(relationship: params[:relationship])
        render json: {status: :success}
    end

    def updateDetails
        @memorial.update(memorial_details_params)
        @memorial.relationships.where(account: user()).first.update(relationship: params[:relationship])

        return render json: {memorial: MemorialSerializer.new( @memorial ).attributes, status: "updated details"}
    end

    def leaveMemorial       
        # leave memorial page for family and friends
        # return render json: {message: "Creator cannot leave memorial."}, status: 404 unless @memorial.relationships.where(account: user()).first != nil
        return render json: {message: "Creator cannot leave memorial."}, status: 400 unless @memorial.pageowner.account_id != user().id
        return render json: {message: "User is not part of the family or friends."}, status: 400 unless @memorial.relationships.where(account: user()).first != nil
        
        # creator leaves memorial if pageadmin exists
        if user().has_role? :pageadmin, @memorial && AlmUser.with_role(:pageadmin, @memorial).count != 1
            if @memorial.relationships.where(account: user()).first.destroy 
                user().remove_role :pageadmin, @memorial
                render json: {}, status: 200
            end
        elsif @memorial.relationships.where(account: user()).first.destroy
            render json: {}, status: 200
        else
            render json: {}, status: 401
        end
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
        return render json: {status: "Oops! Looks like your account is not registered as All Lives Matter account. Register to continue."} unless user.account_type == 2
    end

    def verify_create_params
        return render json: {error: "#{check} is empty"} unless params_presence(memorial_params) == true
    end

    def verify_update_params
        return render json: {error: "#{check} is empty"} unless params_presence(memorial_details_params) == true
    end

    def verify_update_images_params
        return render json: {error: "#{check} is empty"} unless params_presence(memorial_images_params) == true
    end

    def verify_relationship
        return render json: {status: "You're not part of the family or friends"} unless @memorial.relationships.where(account: user()).first.update(relationship: params[:relationship]) == true
    end

    def verify_page_admin
        return render json: {status: "Access Denied"} if user().has_role? :pageadmin, @memorial == false
    end

    def memorial_params
        params.require(:memorial).permit(:name, :description, :birthplace, :dob, :rip, :cemetery, :country, :backgroundImage, :profileImage, :longitude, :latitude, imagesOrVideos: [])
    end

    def memorial_details_params
        params.permit(:birthplace, :dob, :rip, :cemetery, :country, :name, :description, :longitude, :latitude)
    end

    def memorial_images_params
        params.permit(:backgroundImage, :profileImage, imagesOrVideos: [])
    end
end
