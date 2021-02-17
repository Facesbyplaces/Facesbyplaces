class Api::V1::Followers::FollowersController < ApplicationController
    before_action :check_user
    before_action :no_guest_users
    
    def followStatus
        if Follower.where(account: user(), page_type: params[:page_type], page_id: params[:page_id]).first == nil
            render json: {follow: false}
        else
            render json: {follow: true}
        end
    end

    def followOrUnfollow
        if params[:follow].downcase == 'true'
            if Follower.where(account: user(), page_type: params[:page_type], page_id: params[:page_id]).first == nil && Relationship.where(page_type: params[:page_type], page_id: params[:page_id], account: user()).first == nil
                follower = Follower.new(follower_params)
                follower.account = user()
                if follower.save 
                    render json: {status: "Success", follower: follower, user: user}
                else
                    render json: {success: false, errors: follower }, status: 500
                end
            else
                render json: {success: false, errors: "You either followed this page already or you are part of the family or a friend." }, status: 409
            end
        else
            follower = Follower.where(page_type: params[:page_type], page_id: params[:page_id], account: user()).first
            if follower
                if follower.destroy 
                    render json: {status: "Unfollowed"}
                else
                    render json: {success: false, errors: follower }, status: 500
                end
            else
                render json: {success: false, errors: "You are not a follower of this page." }, status: 409
            end
        end

    end

    private
    def follower_params
        params.permit(:page_type, :page_id)
    end
end
