class Api::V1::Followers::FollowersController < ApplicationController
    def follow
        follower = Follower.new(follower_params)
        follower.user = user()
        if follower.save 
            render json: {status: "Success"}
        else
            render json: {status: "Error"}
        end
    end

    def unfollow
        follower = Follower.where(page_type: params[:page_type], page_id: params[:page_id], user: user()).first
        follower.destroy 
        render json: {status: "Unfollowed"}
    end

    private
    def follower_params
        params.require(:follower).permit(:page_type, :page_id)
    end
end
