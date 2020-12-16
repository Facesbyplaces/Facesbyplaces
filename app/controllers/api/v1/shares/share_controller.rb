class Api::V1::Shares::ShareController < ApplicationController
    # include Shareable
    before_action :authenticate_user!

    def create
        @share = Share.new(shares_params)
        @share.save!
        
        render json: {
            success: true,
            share_id:       @share.id, 
            user_id:        @share.user_id,
            status: 200}, status: 200
    end

    def index 
        shares = Share.where(user_id: current_user.id)

        render json: {
            # paginations: {
            #     is_last_page: !@pagy.next.present?,
            #     count: @pagy.count,
            #     url: api_v1_shares_share_index_url(start: params[:start].to_i + 10, length: 10),
            #     page: @pagy.page
            # },
            shares: 
                shares.map{ |share| {
                    share_id:       share.id, 
                    user_id:        share.user_id,
                    post:           PostSerializer.new( Post.find(share.post_id) ).attributes,
                    description:    share.description,
                }},
            status: 200 }
             
        # render json: {post: PostSerializer.new( post ).attributes}
        # paginate shares, per_page: numberOfPage
    end

    private

    def shares_params
        params.permit(:content_type_id,)
    end

end
