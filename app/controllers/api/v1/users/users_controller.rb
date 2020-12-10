class Api::V1::Users::UsersController < ApplicationController
    before_action :authenticate_user!
    
    def edit
        @user = User.find(params[:id])
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
            user = User.find(user().id)
            user.update(updateDetails_params)
            render json: UserSerializer.new( user ).attributes
        else
            render json: {error: "no current user"}, status: 404
        end
    end

    def getDetails
        user = User.find(params[:user_id])

        render json: {
            first_name: user.first_name, 
            last_name: user.last_name,
            email: user.email,
            phone_number: user.phone_number,
            question: user.question
        }
    end

    def changePassword
        
    end

    def updateOtherInfos
        if user()
            user = User.find(user().id)
            user.update(updateOtherInfos_params)
            render json: UserSerializer.new( user ).attributes
        else
            render json: {error: "no current user"}, status: 404
        end
    end

    def getOtherInfos
        user = User.find(params[:user_id])

        render json: {
            birthdate: user.birthdate, 
            birthplace: user.birthplace,
            email: user.email,
            address: user.address,
            phone_number: user.phone_number,
        }
    end

    def show
        user = User.find(params[:user_id])
        render json: UserSerializer.new( user ).attributes
    end

    def posts
        # Posts that they created or owned
        user = User.find(params[:user_id])
        posts = Post.where(user: user).order(created_at: :desc)
        
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
        user = User.find(params[:user_id])
        # Own or part of fam or friend of page
        owned = user.relationships.select("page_type, page_id")
        # Followed
        followed = user.followers.select("page_type, page_id")

        render json: {
            owned: ActiveModel::SerializableResource.new(
                        owned, 
                        each_serializer: PageSerializer
                    ),
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