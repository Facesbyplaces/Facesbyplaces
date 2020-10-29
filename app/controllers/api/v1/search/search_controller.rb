class Api::V1::Search::SearchController < ApplicationController
    def posts
        posts = Post.joins("INNER JOIN #{pages_sql} ON pages.id = posts.page_id AND posts.page_type = pages.object_type")
                    .where("pages.name LIKE :search or pages.country LIKE :search or pages.description LIKE :search", search: params[:keywords])
                    .select("posts.*")
        
        paginate posts, per_page: numberOfPage
    end

    def memorials
        memorials = Pageowner.joins("INNER JOIN #{pages_sql} ON pages.id = pageowners.page_id AND pageowners.page_type = pages.object_type")
                            .where("pages.name LIKE :search or pages.country LIKE :search or pages.description LIKE :search", search: params[:keywords])
                            
        paginate memorials, per_page: numberOfPage
    end
end
