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

    def update_params
        params.permit(:first_name, :last_name, :phone_number, :email, :username, :image)
    end

    def update

        if current_user.present?
            @user = User.find(params[:id])
            @user.update(update_params)

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

    end

    def show
        if current_user.present?
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
    end

    def notifSettingsStatus
        render json: {
            newMemorial: user().notifsetting.newMemorial,
            newAcitivites: user().notifsetting.newAcitivites,
            postLikes: user().notifsetting.postLikes,
            postComments: user().notifsetting.postComments,
            addFamily: user().notifsetting.addFamily,
            addFriends: user().notifsetting.addFriends,
            addAdmin: user().notifsetting.addAdmin,
        }
    end

    def newMemorial
        if params[:setting].downcase == 'true'
            user().notifsetting.update(newMemorial: true)
        else
            user().notifsetting.update(newMemorial: false)
        end

        render json: {}, status: 200
    end

    def newAcitivites
        if params[:setting].downcase == 'true'
            user().notifsetting.update(newAcitivites: true)
        else
            user().notifsetting.update(newAcitivites: false)
        end

        render json: {}, status: 200
    end

    def postLikes
        if params[:setting].downcase == 'true'
            user().notifsetting.update(postLikes: true)
        else
            user().notifsetting.update(postLikes: false)
        end

        render json: {}, status: 200
    end

    def postComments
        if params[:setting].downcase == 'true'
            user().notifsetting.update(postComments: true)
        else
            user().notifsetting.update(postComments: false)
        end

        render json: {}, status: 200
    end

    def addFamily
        if params[:setting].downcase == 'true'
            user().notifsetting.update(addFamily: true)
        else
            user().notifsetting.update(addFamily: false)
        end

        render json: {}, status: 200
    end

    def addFriends
        if params[:setting].downcase == 'true'
            user().notifsetting.update(addFriends: true)
        else
            user().notifsetting.update(addFriends: false)
        end

        render json: {}, status: 200
    end

    def addAdmin
        if params[:setting].downcase == 'true'
            user().notifsetting.update(addAdmin: true)
        else
            user().notifsetting.update(addAdmin: false)
        end

        render json: {}, status: 200
    end
end