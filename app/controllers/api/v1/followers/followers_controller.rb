class Api::V1::Followers::FollowersController < ApplicationController
    include Followerable
    before_action :authenticate_user
    before_action :no_guest_users
    before_action :set_follower, except: [:followStatus]
    before_action :set_page, only: [:follow]
    
    def followStatus
        Follower.where(account: user(), page_type: params[:page_type], page_id: params[:page_id]).first == nil ? (render json: {follow: false}) : (render json: {follow: true})
    end

    def follow
        return render json: {success: false, errors: @follower }, status: 500 unless @follower.save 
        message = "#{user().first_name} followed your memorial."
        send_notif(@page.pageowner.account, message, @page.page_name.capitalize)
        render json: {status: "Success", follower: @follower, user: user}
    end

    def unfollow
        return render json: {success: false, errors: "You are not a follower of this page." }, status: 409 unless @follower
        return render json: {success: false, errors: @follower }, status: 500 unless @follower.destroy
        render json: {status: "Unfollowed"}
    end

    private

    def follower_params
        params.permit(:page_type, :page_id)
    end

    def send_notif(user, message, notif_type)
        Notification.create(recipient: user, actor: user(), action: message, postId: params[:page_id], read: false, notif_type: notif_type)            
                    
        #Push Notification
        device_token = user.device_token
        title = "FacesbyPlaces Notification"
        PushNotification(device_token, title, message, user, user(), params[:page_id], notif_type, " ")
    end
end
