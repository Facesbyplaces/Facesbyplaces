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
        if users.total_count == 0 || (users.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif users.total_count < numberOfPage
            itemsremaining = users.total_count 
        else
            itemsremaining = users.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        users: ActiveModel::SerializableResource.new(
                            users, 
                            each_serializer: UserSerializer
                        )
                    }
    end

    def allUsers
        users = User.all.where.not(guest: true, username: "admin")
        # _except(User.guest).order("users.id DESC")
        alm_users = AlmUser.all

        # BLM Users
        users = users.page(params[:page]).per(numberOfPage)
        if users.total_count == 0 || (users.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif users.total_count < numberOfPage
            itemsremaining = users.total 
        else
            itemsremaining = users.total_count - (params[:page].to_i * numberOfPage)
        end

        # ALM Users
        alm_users = alm_users.page(params[:page]).per(numberOfPage)
        if alm_users.total_count == 0 || (alm_users.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif alm_users.total_count < numberOfPage
            itemsremaining = alm_users.total 
        else
            itemsremaining = alm_users.total_count - (params[:page].to_i * numberOfPage)
        end

        allUsers = users.order("users.id DESC") + alm_users.order("alm_users.id DESC")

        render json: {  itemsremaining:  itemsremaining,
                        users: {
                            blm: users,
                            alm: alm_users
                        },
                    }
    end

    def showUser
        # image = user.image ? rails_blob_url(user.image) : nil
        if params[:account_type] == '1'
            user = User.find(params[:id]) 
        else
            user = AlmUser.find(params[:id]) 
        end

        render json: UserSerializer.new( user ).attributes
    end

    def editUser
        if params[:account_type].to_i == 1
            user = User.find(params[:id])
        else
            user = AlmUser.find(params[:id])
        end

        if user != nil
            user.update(editUser_params)
            if user.errors.present?
                render json: {success: false, errors: user.errors.full_messages, status: 404}, status: 200
            else
                render json: {success: true, message: "Successfully Edited User", user: user, status: 200}, status: 200
            end
        else
            render json: {error: "pls login"}, status: 422
        end
    end

    def deleteUser
        if params[:account_type].to_i == 1
            user = User.find(params[:id])
        else
            user = AlmUser.find(params[:id])
        end

        if user != nil
            user.destroy!
            if user.errors.present?
                render json: {success: false, errors: user.errors.full_messages, status: 404}, status: 200
            else
                render json: {success: true, message: "Successfully Deleted User", user: user, status: 200}, status: 200
            end
        else
            render json: {error: "pls login"}, status: 422
        end
    end

    def contactUser
        message = params[:message]
        if params[:account_type] == '1' || 1
            userEmail = User.find(params[:id]).email
        else
            userEmail = AlmUser.find(params[:id]).email
        end
        subject = params[:subject]

        ContactUserMailer.with(message: message, email: userEmail, subject: subject).contact_user.deliver_later

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
end