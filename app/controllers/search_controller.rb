class SearchController < ApplicationController
    def posts
        posts = Post.where('body LIKE :search or location LIKE :search', search: params[:keywords])

        render json: posts
    end

    def memorials
        memorials = Memorial.where('name LIKE :search or country LIKE :search or cemetery LIKE :search', search: params[:keywords])
        
        render json: memorials
    end
end
