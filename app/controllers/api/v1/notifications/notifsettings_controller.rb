class Api::V1::Notifications::NotifsettingsController < ApplicationController
    
    # Add pages or posts to ignore in notifs
    def create
        ignore = Notifsetting.new(ignore_params)
        ignore.user = user()

        ignore.save 

        render json: {status: "Added to ignore notif list"}
    end

    # Remove pages or posts from ignore lists
    def delete
        ignore = Notifsetting.find(params[:ignore_id])
        ignore.destroy 
        render json: {status: "Success"}
    end

    # List of Notifications
    def index
        notifs = user().notifications.order(created_at: :desc)

        paginate notifs, per_page: numberOfPage
    end
    
    
    private
    def ignore_params
        params.permit(:ignore_type, :ignore_id)
    end
    
end
