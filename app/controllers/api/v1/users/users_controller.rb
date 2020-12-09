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

    def changePassword
        
    end

    def updateOtherInfos
        
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

    private
    def update_params
        params.permit(:first_name, :last_name, :email, :phone_number, :security_question)
    end
end