class Api::V1::Admin::UsersController < ApplicationController
    include Userable
    before_action :admin_only
    before_action :set_searched_users, only: [:searchUsers]
    before_action :set_users, only: [:allUsers]
    before_action :set_user, except: [:searchUsers, :allUsers]

    def searchUsers
        render json: {  itemsremaining:  itemsRemaining(@users),
                        users: ActiveModel::SerializableResource.new(
                            @users, 
                            each_serializer: UserSerializer
                        )
                    }
    end

    def allUsers
        render json: {  itemsremaining:  itemsRemaining(@alm_users),
                        users: {
                            blm: @blm_users,
                            alm: @alm_users
                        },
                    }
    end

    def showUser
        render json: UserSerializer.new( @user ).attributes
    end

    def editUser
        return render json: {error: "User not found"}, status: 404 unless @user != nil
        return render json: {success: false, errors: @user.errors.full_messages, status: 404}, status: 404 unless @user.update(editUser_params)
        render json: {success: true, message: "Successfully Edited User", user: @user, status: 200}, status: 200 
    end

    def deleteUser
        return render json: {error: "User not found"}, status: 404 unless @user != nil
        return render json: {success: false, errors: @user.errors.full_messages, status: 404}, status: 404 unless @user.destroy!
        render json: {success: true, message: "Successfully Deleted User", user: @user, status: 200}, status: 200
    end

    def contactUser
        ContactUserMailer.with(message: params[:message], email: @user.email, subject: params[:subject]).contact_user.deliver_later
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
