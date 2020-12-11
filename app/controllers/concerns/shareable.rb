module Shareable
    include ApplicationConcern
  
    def set_share
      @share = Share.find_by_id params[:share_id] || params[:id]
    end
  
    def set_shares
      @pagy, @shares = pagy_shares
    end
  
  
    def pagy_shares
      if current_user.present?
        collection = Share.order(created_at: :desc)
      end
      
      pagy = Pagy.new(
        count: collection.count,
        # page: current_page,
        items: params[:length]
      )
  
      return pagy, collection
        .offset(params[:start]).limit(params[:length])
    end
end