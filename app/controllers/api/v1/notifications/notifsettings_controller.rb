class Api::V1::Notifications::NotifsettingsController < ApplicationController
    before_action :authenticate_user

    def notifSettingsStatus
        render json: user().notifsetting
    end

    def newMemorial
        updateNotif("memorial")
    end

    def newActivities
        updateNotif("activities")
    end

    def postLikes
        updateNotif("likes")
    end

    def postComments
        updateNotif("comments")
    end

    def addFamily
        updateNotif("family")
    end

    def addFriends
        updateNotif("friends")
    end

    def addAdmin
        updateNotif("admin")
    end

    # Mark Notifications as read
    def read
        unreadNotifs = user.notifications.where(read: false)

        unreadNotifs.each do |unreadNotif|
            unreadNotif.update(read: true)
        end

        render json: {status: :success}
    end

    # Number of unread notifications
    def numOfUnread
        number_of_unread_notifs = user().notifications.where(read: false).count

        render json: {number_of_unread_notifs: number_of_unread_notifs}
    end
    
    private

    def ignore_params
        params.permit(:ignore_type, :ignore_id)
    end
    
    def updateNotif(notif)
        case notif
        when "memorial"
            user().notifsetting.update(newMemorial: params[:setting])
        when "activities"
            user().notifsetting.update(newActivities: params[:setting])
        when "likes"
            user().notifsetting.update(postLikes: params[:setting])
        when "comments"
            user().notifsetting.update(postComments: params[:setting])
        when "family"
            user().notifsetting.update(addFamily: params[:setting])
        when "friends"
            user().notifsetting.update(addFriends: params[:setting])
        when "admin"
            user().notifsetting.update(addAdmin: params[:setting])
        else
            return render json: { error: true, message: "Notif not found", status: 404 }, status: 404
        end

        render json: {}, status: 200
    end


end
