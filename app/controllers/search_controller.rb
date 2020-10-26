class SearchController < ApplicationController
    def posts
        posts = Post.joins(:memorial).where('memorials.name LIKE :search or memorials.country LIKE :search or memorials.cemetery LIKE :search or posts.body LIKE :search or posts.location LIKE :search', search: params[:keywords]).select('posts.*')
        
        paginate posts, per_page: numberOfPage
    end

    def memorials
        memorials = Memorial.where('name LIKE :search or country LIKE :search or cemetery LIKE :search', search: params[:keywords])
        
        paginate memorials, per_page: numberOfPage
    end
end
