class Notification::Builder

    def initialize(device_tokens:, title:, message:, recipient:, actor:, data:, type:, postType:)
      @device_tokens    = device_tokens
      @title            = title
      @message          = message
      @recipient        = recipient
      @actor            = actor
      @data             = data
      @type             = type
      @postType         = postType
      @notification     = Notification.new(recipient: @recipient, actor: @actor, action: @message, postId: @data, read: false, notif_type: @type)
    end
  
    def notify
      add_notifications_to_user
      push_notify
    end

    def push_notify
        require 'fcm'

        fcm_client = FCM.new(Rails.application.credentials.dig(:firebase, :server_key))
        options = { 
            "notification": { 
                "title": @title,    
                "body": @message,
                "sound": "default",
            },
            "data": {
                "recipient": @recipient,
                "actor": @actor,
                "dataID": @data,
                "dataType": @type,
                "postType": @postType
            }
        }

        begin
            response = fcm_client.send(@device_tokens, options)
        rescue StandardError => err
            puts        "\n-- PushNotification : Error --\n#{err}"
        end

        puts response
    end
  
    private
        def add_notifications_to_user
            @notification.save
        end
  
  end
  