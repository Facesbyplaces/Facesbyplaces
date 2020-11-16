class Api::V1::Shares::ShareController < ApplicationController
    before_action :authenticate_user!

    def create
        @share = Share.new(shares_params)
        @share.save!

        render json: {
            success: true,
            share_id:       @share.id,
            page_type:      @share.page_type,
            page_id:        @share.page_id,
            user_id:        @share.user_id,  
            post_id:        @share.post_id,
            description:    @share.description,
            status: 200}, status: 200
    end

    def index 
        shares = Share.where(user_id: user)
        
        paginate shares, per_page: numberOfPage
    end

    private

    def shares_params
        params.permit(:page_type, :page_id, :user_id, :post_id, :description)
    end

end
