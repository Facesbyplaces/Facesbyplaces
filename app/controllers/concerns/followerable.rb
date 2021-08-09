module Followerable
    include ApplicationConcern
  
    def set_follower
        if Follower.where(account: user(), page_type: params[:page_type], page_id: params[:page_id]).first == nil && Relationship.where(page_type: params[:page_type], page_id: params[:page_id], account: user()).first == nil
            @follower = Follower.new(follower_params)
            @follower.account = user()
        elsif Follower.where(page_type: params[:page_type], page_id: params[:page_id], account: user()).first
            @follower = Follower.where(page_type: params[:page_type], page_id: params[:page_id], account: user()).first
        else
            render json: {success: false, errors: "You either followed this page already or you are part of the family or a friend." }, status: 409
        end
    end

    def set_page
        if params[:page_type] == "Memorial"
            @page = Memorial.find(params[:page_id])
        elsif params[:page_type] == "Blm"
            @page = Blm.find(params[:page_id])
        end
    end
end