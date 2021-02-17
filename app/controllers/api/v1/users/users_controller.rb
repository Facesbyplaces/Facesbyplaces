class Api::V1::Users::UsersController < ApplicationController
    before_action :check_user, except: [:guest, :create_guest_user]

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
    
    def edit
        if params[:account_type] == "1"
            @user = User.find(params[:id])
        else
            @user = AlmUser.find(params[:id])
        end
        
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

    def getDetails
        if params[:account_type] == "1"
            user = User.find(params[:user_id])
        else
            user = AlmUser.find(params[:user_id])
        end

        render json: {
            first_name: user.first_name, 
            last_name: user.last_name,
            email: user.email,
            phone_number: user.phone_number,
            question: user.question
        }
    end

    def changePassword
        if user().valid_password?(params[:current_password])
            user().password = user().password_confirmation = params[:new_password]
            user().save

            render json: {}, status: 200
        else
            render json: {error: "Incorrect current password"}, status: 406
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

    def getOtherInfos
        if params[:account_type] == "1"
            user = User.find(params[:user_id])
        else
            user = AlmUser.find(params[:user_id])
        end

        render json: {
            birthdate: user.birthdate, 
            birthplace: user.birthplace,
            email: user.email,
            address: user.address,
            phone_number: user.phone_number,
        }
    end

    def show
        if params[:account_type] == "1"
            user = User.find(params[:user_id])
        else
            user = AlmUser.find(params[:user_id])
        end

        render json: UserSerializer.new( user ).attributes
        
        # UserSerializer.new( user ).attributes
    end

    def posts
        # Posts that they created or owned
        if params[:account_type] == "1"
            user = User.find(params[:user_id])
        else
            user = AlmUser.find(params[:user_id])
        end

        posts = Post.where(account: user).order(created_at: :desc)
        
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
        if params[:account_type] == "1"
            user = User.find(params[:user_id])
        else
            user = AlmUser.find(params[:user_id])
        end
        # Own or part of fam or friend of page
        owned = user.relationships.select("page_type, page_id")
        # Followed
        followed = user.followers.select("page_type, page_id")

        owned = owned.page(params[:page]).per(numberOfPage)
        if owned.total_count == 0 || (owned.total_count - (params[:page].to_i * numberOfPage)) < 0
            ownedItemsRemaining = 0
        elsif owned.total_count < numberOfPage
            ownedItemsRemaining = owned.total_count 
        else
            ownedItemsRemaining = owned.total_count - (params[:page].to_i * numberOfPage)
        end

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

    def hideOrUnhideBirthdate
        if params[:hide].downcase == 'true'
            user().update(hideBirthdate: true)
        else
            user().update(hideBirthdate: false)
        end

        render json: {}, status: 200
    end

    def hideOrUnhideBirthplace
        if params[:hide].downcase == 'true'
            user().update(hideBirthplace: true)
        else
            user().update(hideBirthplace: false)
        end

        render json: {}, status: 200
    end

    def hideOrUnhideEmail
        if params[:hide].downcase == 'true'
            user().update(hideEmail: true)
        else
            user().update(hideEmail: false)
        end

        render json: {}, status: 200
    end

    def hideOrUnhideAddress
        if params[:hide].downcase == 'true'
            user().update(hideAddress: true)
        else
            user().update(hideAddress: false)
        end

        render json: {}, status: 200
    end

    def hideOrUnhidePhonenumber
        if params[:hide].downcase == 'true'
            user().update(hidePhonenumber: true)
        else
            user().update(hidePhonenumber: false)
        end

        render json: {}, status: 200
    end

    private
    def updateDetails_params
        params.permit(:first_name, :last_name, :email, :phone_number, :question)
    end

    def updateOtherInfos_params
        params.permit(:birthdate, :birthplace, :email, :address, :phone_number)
    end
end