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

    def users
        users = User.where("first_name LIKE :search or last_name LIKE :search or email LIKE :search or username LIKE :search", search: params[:keywords])

        paginate users, per_page: numberOfPage
    end

    def followers
        case params[:page_type]
        when "Blm"
            page = Blm.find(params[:page_id])
        when "Memorial"
            page = Memorial.find(params[:page_id])
        end 

        # get the followers of the page (users are the followers of the page)
        followers = page.users.where("first_name LIKE :search or last_name LIKE :search or email LIKE :search or username LIKE :search", search: params[:keywords])

        paginate followers, per_page: numberOfPage
    end
end
