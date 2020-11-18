class Api::V1::Notifications::NotifsettingsController < ApplicationController
    before_action :authenticate_user!
    
    # Add pages or posts to ignore in notifs
    def create
        ignore = Notifsetting.new(ignore_params)
        ignore.user = user()

        ignore.save 

        render json: {status: "Added to ignore notif list"}
    end

    # Remove pages or posts from ignore lists
    def delete
        ignore = Notifsetting.find(params[:ignore_id])
        ignore.destroy 
        render json: {status: "Success"}
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
    
end
