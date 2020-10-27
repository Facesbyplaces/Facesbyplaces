class SearchController < ApplicationController
    def posts
        posts = Post.joins("INNER JOIN memorials ON memorials.id = posts.page_id AND posts.page_type = 'Memorial'")
                    # .joins("INNER JOIN blms ON blms.id = posts.page_id AND posts.page_type = 'Blm'")
                    .where("memorials.name LIKE :search", search: params[:keywords])
        
        paginate posts, per_page: numberOfPage
    end

    def memorials
        memorials = Memorial.where('name LIKE :search or country LIKE :search or cemetery LIKE :search', search: params[:keywords])
        
        paginate memorials, per_page: numberOfPage
    end
end
