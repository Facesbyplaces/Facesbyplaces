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
        
        notification = Notification::Builder.new(
            device_tokens:   @page.pageowner.account.device_token,
            title:          "FacesbyPlaces Notification",
            message:        "#{user().first_name} followed your memorial.",
            recipient:      @page.pageowner.account,
            actor:          user(),
            data:           params[:page_id],
            type:           @page.page_name.capitalize,
            postType:       " ",
        )
        notification.notify

        render json: {status: "Success", follower: @follower, user: user()}
    end

    def unfollow
        return render json: {success: false, errors: @follower }, status: 500 unless @follower.destroy
        render json: {status: "Unfollowed"}
    end

    private

    def follower_params
        params.permit(:page_type, :page_id)
    end
end
