class Api::V1::Users::UsersController < ApplicationController
    before_action :authenticate_user

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
    #     if user().valid_password?(params[:current_password])
    #         user().password = user().password_confirmation = params[:new_password]
    #         user().save

    #         render json: {}, status: 200
    #     else
    #         render json: {error: "Incorrect current password"}, status: 406
    #     end
    # end

    def check_password        
        if user().password_update == true
            render json: { success: true, password_updated: user().password_update, status: 200 }, status: 200
        else
            render json: { success: true, password_updated: user().password_update, status: 200 }, status: 200  
        end
    end
    
    def edit
        @user = fetched_user
        
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
        if user()
            user().update(updateDetails_params)
            render json: UserSerializer.new( user() ).attributes
        else
            render json: {error: "no current user"}, status: 404
        end
    end

    def updateOtherInfos
        if user()
            user().update(updateOtherInfos_params)
            render json: UserSerializer.new( user() ).attributes
        else
            render json: {error: "no current user"}, status: 404
        end
    end

    def getDetails
        @user = fetched_user

        render json: {
            first_name: @user.first_name, 
            last_name: @user.last_name,
            email: @user.email,
            phone_number: @user.phone_number,
            question: @user.question
        }
    end

    def getOtherInfos
        @user = fetched_user

        render json: {
            birthdate: @user.birthdate, 
            birthplace: @user.birthplace,
            email: @user.email,
            address: @user.address,
            phone_number: @user.phone_number,
        }
    end

    def otherDetailsStatus
        if user()
            render json: {
                hideBirthdate: user().hideBirthdate,
                hideBirthplace: user().hideBirthplace,
                hideEmail: user().hideEmail,
                hideAddress: user().hideAddress,
                hidePhonenumber: user().hidePhonenumber,
            }
        else
            render json: {error: "no current user"}, status: 404
        end
    end

    def show
        @user = fetched_user

        render json: UserSerializer.new( @user ).attributes
    end

    def posts
        @user = fetched_user

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
        @user = fetched_user

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

    def sign_up_params
        params.permit(:facebook_id, :google_id, :account_type, :first_name, :last_name, :phone_number, :email, :username)
    end

    def updateDetails_params
        params.permit(:first_name, :last_name, :email, :phone_number, :question)
    end

    def updateOtherInfos_params
        params.permit(:birthdate, :birthplace, :email, :address, :phone_number)
    end

    def fetched_user
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
            user().update(hideBirthdate: hide)
        when "birthplace"
            user().update(hideBirthplace: hide)
        when "email"
            user().update(hideEmail: hide)
        when "address"
            user().update(hideAddress: hide)
        when "phone_number"
            user().update(hidePhonenumber: hide)
        else
            return render json: { message: "Detail unavailable", status: 401 }, status: 401
        end

        render json: {}, status: 200
    end

end