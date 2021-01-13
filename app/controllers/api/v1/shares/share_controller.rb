class Api::V1::Shares::ShareController < ApplicationController
    # include Shareable
    before_action :check_user

    def getLink
        case params[:content_type].to_i
        when 1      # Post
            render json: {url: "http://fbp.dev1.koda.ws/share?content_type=Post&content_id=#{params[:content_id]}"}
        when 2      # Memorial
            case params[:account_type].to_i
            when 1      # Blm
                render json: {url: "http://fbp.dev1.koda.ws/share?content_type=Blm&content_id=#{params[:content_id]}"}
            when 2      # Alm
                render json: {url: "http://fbp.dev1.koda.ws/share?content_type=Alm&content_id=#{params[:content_id]}"}
            end
        end
    end
end
