class Api::V1::Notifications::NotifsettingsController < ApplicationController
    before_action :check_user

    def notifSettingsStatus
        render json: user().notifsetting
    end

    def newMemorial
        if params[:setting].downcase == 'true'
            user().notifsetting.update(newMemorial: true)
        else
            user().notifsetting.update(newMemorial: false)
        end

        render json: {}, status: 200
    end

    def newActivities
        if params[:setting].downcase == 'true'
            user().notifsetting.update(newActivities: true)
        else
            user().notifsetting.update(newActivities: false)
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

    # def push_notif
    #     notification = user().notifications.where(read: false).first 

    #     render json: {notification: ActiveModel::SerializableResource.new(
    #                                     notification, 
    #                                     each_serializer: NotificationSerializer
    #                                 )
    #                 }, status: 200
    # end

    def pushNotification
        require 'fcm'
        
        device_tokens = params[:device_tokens]

        def self.client
            FCM.new(Rails.application.credentials.dig(:firebase, :server_key))
        end

        def self.send(device_tokens, data)
            begin
              fcm       = pushNotification.client
              options   = {
                "notification": {
                  "title": data[:title],
                  "body": data[:body]
                }
              }
        
              response  = fcm.send(device_tokens, options)
            rescue StandardError => err
              puts        "\n-- PushNotification : Error --\n#{err}"
              logger.info "\n-- PushNotification : Error --\n#{err}"
            end
        end
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
