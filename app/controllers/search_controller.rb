class SearchController < ApplicationController
    def posts
        posts = Post.joins(:page)
        
        paginate posts, per_page: numberOfPage
    end

    def memorials
        memorials = Memorial.where('name LIKE :search or country LIKE :search or cemetery LIKE :search', search: params[:keywords])
        
        paginate memorials, per_page: numberOfPage
    end
end
