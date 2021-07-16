class Api::V1::Users::UsersController < ApplicationController
    set_account_type = 1 ? (before_action :authenticate_user!) : (before_action :authenticate_alm_user!) 

    ## SIGN_IN AS GUEST
    # def blm_guest
    #     User.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_blm_guest_user.id : session[:guest_user_id])
    # end

    # def alm_guest
    #     AlmUser.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_alm_guest_user.id : session[:guest_user_id])
    # end
      
    # def create_blm_guest_user
    #     u = User.create(:username => "guest", :email => "guest_#{Time.now.to_i}#{rand(99)}@example.com", :guest => true, :account_type => 1)
    #     u.save(:validate => false)
    #     render json: { success: true, user:  u, status: 200 }, status: 200
    #     u
    # end

    # def create_alm_guest_user
    #     u = AlmUser.create(:username => "guest", :email => "guest_#{Time.now.to_i}#{rand(99)}@example.com", :guest => true, :account_type => 2)
    #     u.save(:validate => false)
    #     render json: { success: true, user:  u, status: 200 }, status: 200
    #     u
    # end
    ##

    # def changePassword
    #     if signed_in_user.valid_password?(params[:current_password])
    #         signed_in_user.password = signed_in_user.password_confirmation = params[:new_password]
    #         signed_in_user.save

    #         render json: {}, status: 200
    #     else
    #         render json: {error: "Incorrect current password"}, status: 406
    #     end
    # end

    def check_password        
        if signed_in_user.password_update == true
            render json: { success: true, password_updated: signed_in_user.password_update, status: 200 }, status: 200
        else
            render json: { success: true, password_updated: signed_in_user.password_update, status: 200 }, status: 200  
        end
    end
    
    def edit
        @user = user
        
        render json: {
            success: true, 
            first_name: @user.first_name, 
            last_name: @user.last_name, 
            phone_number: @user.phone_number,
            email: @user.email,
            username: @user.username,
            image: @user.image,
            status: 200}, status: 200
    end

    def updateDetails
        if signed_in_user
            signed_in_user.update(updateDetails_params)
            render json: UserSerializer.new( signed_in_user ).attributes
        else
            render json: {error: "no current user"}, status: 404
        end
    end

    def updateOtherInfos
        if signed_in_user
            signed_in_user.update(updateOtherInfos_params)
            render json: UserSerializer.new( signed_in_user ).attributes
        else
            render json: {error: "no current user"}, status: 404
        end
    end

    def getDetails
        @user = user

        render json: {
            first_name: @user.first_name, 
            last_name: @user.last_name,
            email: @user.email,
            phone_number: @user.phone_number,
            question: @user.question
        }
    end

    def getOtherInfos
        @user = user

        render json: {
            birthdate: @user.birthdate, 
            birthplace: @user.birthplace,
            email: @user.email,
            address: @user.address,
            phone_number: @user.phone_number,
        }
    end

    def otherDetailsStatus
        if signed_in_user
            render json: {
                hideBirthdate: signed_in_user.hideBirthdate,
                hideBirthplace: signed_in_user.hideBirthplace,
                hideEmail: signed_in_user.hideEmail,
                hideAddress: signed_in_user.hideAddress,
                hidePhonenumber: signed_in_user.hidePhonenumber,
            }
        else
            render json: {error: "no current user"}, status: 404
        end
    end

    def show
        @user = user

        render json: UserSerializer.new( @user ).attributes
    end

    def posts
        @user = user

        posts = Post.where(account: @user).order(created_at: :desc)
        
        posts = posts.page(params[:page]).per(numberOfPage)
        if posts.total_count == 0 || (posts.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif posts.total_count < numberOfPage
            itemsremaining = posts.total_count 
        else
            itemsremaining = posts.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        posts: ActiveModel::SerializableResource.new(
                                posts, 
                                each_serializer: PostSerializer
                            )
                    }
    end

    def memorials
        @user = user

        # Own or part of fam or friend of page
        owned = @user.relationships.select("page_type, page_id")
        
        owned = owned.page(params[:page]).per(numberOfPage)
        if owned.total_count == 0 || (owned.total_count - (params[:page].to_i * numberOfPage)) < 0
            ownedItemsRemaining = 0
        elsif owned.total_count < numberOfPage
            ownedItemsRemaining = owned.total_count 
        else
            ownedItemsRemaining = owned.total_count - (params[:page].to_i * numberOfPage)
        end

        # Followed
        followed = @user.followers.select("page_type, page_id")

        followed = followed.page(params[:page]).per(numberOfPage)
        if followed.total_count == 0 || (followed.total_count - (params[:page].to_i * numberOfPage)) < 0
            followedItemsRemaining = 0
        elsif followed.total_count < numberOfPage
            followedItemsRemaining = followed.total_count 
        else
            followedItemsRemaining = followed.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {
            ownedItemsRemaining: ownedItemsRemaining,
            owned: ActiveModel::SerializableResource.new(
                        owned, 
                        each_serializer: PageSerializer
                    ),
            followedItemsRemaining: followedItemsRemaining,
            followed: ActiveModel::SerializableResource.new(
                        followed, 
                        each_serializer: PageSerializer
                    ),
        }
    end

    def hideOrUnhideBirthdate
        hideOrUnhide("birthdate")
    end

    def hideOrUnhideBirthplace
        hideOrUnhide("birthplace")
    end

    def hideOrUnhideEmail
        hideOrUnhide("email")
    end

    def hideOrUnhideAddress
        hideOrUnhide("address")
    end

    def hideOrUnhidePhonenumber
        hideOrUnhide("phone_number")
    end

    private

    def signed_in_user
        if current_alm_user
            return current_alm_user
        else
            return current_user
        end
    end

    def sign_up_params
        params.permit(:facebook_id, :google_id, :account_type, :first_name, :last_name, :phone_number, :email, :username)
    end

    def updateDetails_params
        params.permit(:first_name, :last_name, :email, :phone_number, :question)
    end

    def updateOtherInfos_params
        params.permit(:birthdate, :birthplace, :email, :address, :phone_number)
    end

    def user
        if params[:account_type] == "1"
            return user = User.find(params[:user_id])
        else
            return user = AlmUser.find(params[:user_id])
        end
    end

    def hideOrUnhide(detail)
        if params[:hide].downcase == 'true'
            hide = true
        else
            hide = false
        end

        case detail 
        when "birthdate"
            signed_in_user.update(hideBirthdate: hide)
        when "birthplace"
            signed_in_user.update(hideBirthplace: hide)
        when "email"
            signed_in_user.update(hideEmail: hide)
        when "address"
            signed_in_user.update(hideAddress: hide)
        when "phone_number"
            signed_in_user.update(hidePhonenumber: hide)
        else
            return render json: { message: "Detail unavailable", status: 401 }, status: 401
        end

        render json: {}, status: 200
    end

end