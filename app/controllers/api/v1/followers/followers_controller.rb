class Api::V1::Followers::FollowersController < ApplicationController
    before_action :authenticate_user!
    
    def follow
        if Follower.where(user: user(), page_type: params[:follower][:page_type], page_id: params[:follower][:page_id]).first == nil
            follower = Follower.new(follower_params)
            follower.user = user()
            if follower.save 
                render json: {status: "Success"}
            else
                render json: {}, status: 500
            end
        else
            render json: {}, status: 409
        end
    end

    def unfollow
        follower = Follower.where(page_type: params[:page_type], page_id: params[:page_id], user: user()).first
        if follower
            if follower.destroy 
                render json: {status: "Unfollowed"}
            else
                render json: {}, status: 500
            end
        else
            render json: {}, status: 404
        end
    end

    private
    def follower_params
        params.require(:follower).permit(:page_type, :page_id)
    end
end
