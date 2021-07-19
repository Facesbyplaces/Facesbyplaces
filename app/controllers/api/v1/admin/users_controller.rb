class Api::V1::Admin::UsersController < ApplicationController
    before_action :admin_only

    def searchUsers
        users = PgSearch.multisearch(params[:keywords]).where(searchable_type: ['AlmUser', 'User']).map{|searchObject| 
            if searchObject.searchable_type == 'User'
                User.find(searchObject.searchable_id)
            else
                AlmUser.find(searchObject.searchable_id)
            end
        }.flatten.uniq

        users = Kaminari.paginate_array(users).page(params[:page]).per(numberOfPage)

        render json: {  itemsremaining:  itemsRemaining(users),
                        users: ActiveModel::SerializableResource.new(
                            users, 
                            each_serializer: UserSerializer
                        )
                    }
    end

    def allUsers
        users = User.all.where.not(guest: true, username: "admin")
        alm_users = AlmUser.all

        # BLM Users
        users = users.page(params[:page]).per(numberOfPage)
        itemsremaining = itemsRemaining(users)

        # ALM Users
        alm_users = alm_users.page(params[:page]).per(numberOfPage)
        itemsremaining = itemsRemaining(alm_users)


        render json: {  itemsremaining:  itemsremaining,
                        users: {
                            blm: users,
                            alm: alm_users
                        },
                    }
    end

    def showUser
        @user = fetched_user

        render json: UserSerializer.new( @user ).attributes
    end

    def editUser
        @user = fetched_user

        if @user != nil
            @user.update(editUser_params)
            if @user.errors.present?
                render json: {success: false, errors: @user.errors.full_messages, status: 404}, status: 404
            else
                render json: {success: true, message: "Successfully Edited User", user: @user, status: 200}, status: 200
            end
        else
            render json: {error: "User not found"}, status: 404
        end
    end

    def deleteUser
        @user = fetched_user

        if @user != nil
            @user.destroy!
            if @user.errors.present?
                render json: {success: false, errors: @user.errors.full_messages, status: 404}, status: 404
            else
                render json: {success: true, message: "Successfully Deleted User", user: @user, status: 200}, status: 200
            end
        else
            render json: {error: "User not found"}, status: 404
        end
    end

    def contactUser
        @user = fetched_user
        message = params[:message]
        subject = params[:subject]

        ContactUserMailer.with(message: message, email: @user.email, subject: subject).contact_user.deliver_later

        render json: {status: "Email Sent"}
    end

    private

    def editUser_params
        params.permit(:id, :account_type, :username, :first_name, :last_name, :phone_number)
    end

    def admin_only
        unless user().has_role? :admin
            return render json: {status: "Must be an admin to continue"}, status: 401
        end
    end

    def fetched_user
        if params[:account_type].to_i == 1
            return User.find(params[:id])
        else
            return AlmUser.find(params[:id])
        end
    end

    def itemsRemaining(users)
        if users.total_count == 0 || (users.total_count - (params[:page].to_i * numberOfPage)) < 0
            return 0
        elsif users.total_count < numberOfPage
            return users.total_count 
        else
            return users.total_count - (params[:page].to_i * numberOfPage)
        end
    end

    
end