class Api::V1::Notifications::NotifsettingsController < ApplicationController
    before_action :authenticate_user

    def notifSettingsStatus
        render json: user().notifsetting
    end

    def newMemorial
        Notifsettings::Update.new( user: user(), setting: params[:setting], type: "memorial" ).execute
        render json: {}, status: 200
    end

    def newActivities
        Notifsettings::Update.new( user: user(), setting: params[:setting], type: "activities" ).execute
        render json: {}, status: 200
    end

    def postLikes
        Notifsettings::Update.new( user: user(), setting: params[:setting], type: "likes" ).execute
        render json: {}, status: 200
    end

    def postComments
        Notifsettings::Update.new( user: user(), setting: params[:setting], type: "comments" ).execute
        render json: {}, status: 200
    end

    def addFamily
        Notifsettings::Update.new( user: user(), setting: params[:setting], type: "family" ).execute
        render json: {}, status: 200
    end

    def addFriends
        Notifsettings::Update.new( user: user(), setting: params[:setting], type: "friends" ).execute
        render json: {}, status: 200
    end

    def addAdmin
        Notifsettings::Update.new( user: user(), setting: params[:setting], type: "admin" ).execute
        render json: {}, status: 200
    end

    # Mark Notifications as read
    def read
        unreadNotifs.each do |unreadNotif|
            unreadNotif.update(read: true)
        end

        render json: {status: :success}
    end

    # Number of unread notifications
    def numOfUnread
        render json: {number_of_unread_notifs: unreadNotifs.count}
    end
    
    private

    def ignore_params
        params.permit(:ignore_type, :ignore_id)
    end

    def unreadNotifs
        return user().notifications.where(read: false)
    end


end
