class Api::V1::Users::UsersController < ApplicationController
    include Postable
    before_action :authenticate_user
    before_action :set_posts, only: [:posts]

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
        render json: { success: true, password_updated: user().password_update, status: 200 }, status: 200
    end

    def updateDetails
        if user()
            user().update(updateDetails_params)
            render json: UserSerializer.new( user() ).attributes
        else
            render json: {error: "No current user"}, status: 404
        end
    end

    def updateOtherInfos
        if user()
            user().update(updateOtherInfos_params)
            render json: UserSerializer.new( user() ).attributes
        else
            render json: {error: "No current user"}, status: 404
        end
    end

    def getDetails
        if user()
            render json: {
                first_name: user().first_name, 
                last_name: user().last_name,
                email: user().email,
                phone_number: user().phone_number,
                question: user().question
            }
        else
            render json: {error: "No current user"}, status: 404
        end
    end

    def getOtherInfos
        if user()
            render json: {
                birthdate: user().birthdate, 
                birthplace: user().birthplace,
                email: user().email,
                address: user().address,
                phone_number: user().phone_number,
            }
        else
            render json: {error: "No current user"}, status: 404
        end
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
            render json: {error: "No current user"}, status: 404
        end
    end

    def show
        @user = User.find_by(id: params[:user_id]), account_type: params[:account_type])

        if @user
            render json: UserSerializer.new( @user ).attributes
        else
            render json: {error: "No current user"}, status: 404
        end
    end

    def posts
        render json: {  itemsremaining:  itemsRemaining(@posts),
                        posts: ActiveModel::SerializableResource.new(
                                @posts, 
                                each_serializer: PostSerializer
                            )
                    }
    end

    def memorials
        render json: {
            ownedItemsRemaining: itemsRemaining(user().owned(params[:page])),
            owned: ActiveModel::SerializableResource.new(
                        user().owned(params[:page]), 
                        each_serializer: PageSerializer
                    ),
            followedItemsRemaining: itemsRemaining(user().followed(params[:page])),
            followed: ActiveModel::SerializableResource.new(
                        user().followed(params[:page]), 
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

    def hideOrUnhide(detail)
        case detail 
        when "birthdate"
            user().update(hideBirthdate: params[:hide])
        when "birthplace"
            user().update(hideBirthplace: params[:hide])
        when "email"
            user().update(hideEmail: params[:hide])
        when "address"
            user().update(hideAddress: params[:hide])
        when "phone_number"
            user().update(hidePhonenumber: params[:hide])
        else
            return render json: { message: "Detail unavailable", status: 401 }, status: 401
        end

        render json: {}, status: 200
    end

    def itemsRemaining(data)
        if data.total_count == 0 || (data.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif data.total_count < numberOfPage
            itemsremaining = data.total_count 
        else
            itemsremaining = data.total_count - (params[:page].to_i * numberOfPage)
        end
    end

end