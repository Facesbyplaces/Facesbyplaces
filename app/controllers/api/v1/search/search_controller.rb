class Api::V1::Search::SearchController < ApplicationController
    def posts
        # posts = Post.joins("INNER JOIN #{pages_sql} ON pages.id = posts.page_id AND posts.page_type = pages.object_type")
        #             .where("lower(pages.name) LIKE :search OR lower(pages.country) LIKE :search OR lower(pages.description) LIKE :search OR lower(posts.body) LIKE :search", search: params[:keywords].downcase)
        #             .select("posts.*")
        
        posts = Post.search_post(params[:keywords])
        
        posts = posts.page(params[:page]).per(numberOfPage)
        if posts.total_count == 0 || (posts.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif posts.total_count < numberOfPage
            itemsremaining = posts.total_count 
        else
            itemsremaining = posts.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        posts: ActiveModel::SerializableResource.new(
                            posts, 
                            each_serializer: PostSerializer
                        )
                    }
    end

    def memorials
        memorials = Pageowner.joins("INNER JOIN #{pages_sql} ON pages.id = pageowners.page_id AND pageowners.page_type = pages.object_type")
                            .where("pages.name LIKE :search or pages.country LIKE :search or pages.description LIKE :search", search: params[:keywords])
                            
        memorials = memorials.page(params[:page]).per(numberOfPage)
        if memorials.total_count == 0 || (memorials.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif memorials.total_count < numberOfPage
            itemsremaining = memorials.total_count 
        else
            itemsremaining = memorials.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        memorials: ActiveModel::SerializableResource.new(
                            memorials, 
                            each_serializer: PageownerSerializer
                        )
                    }
    end

    def users
        users = User.where("first_name LIKE :search or last_name LIKE :search or email LIKE :search or username LIKE :search", search: params[:keywords])

        users = users.page(params[:page]).per(numberOfPage)
        if users.total_count == 0 || (users.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif users.total_count < numberOfPage
            itemsremaining = users.total_count 
        else
            itemsremaining = users.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        users: users
                    }
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

        followers = followers.page(params[:page]).per(numberOfPage)
        if followers.total_count == 0 || (followers.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif followers.total_count < numberOfPage
            itemsremaining = followers.total_count 
        else
            itemsremaining = followers.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        followers: followers
                    }
    end

    def nearby
        lon = params[:longitude].to_f
        lat = params[:latitude].to_f

        user_location = Geocoder.search([lat,lon])

        blm = Blm.near([lat,lon], 50)
        
        blm = blm.page(params[:page]).per(numberOfPage)
        if blm.total_count == 0 || (blm.total_count - (params[:page].to_i * numberOfPage)) < 0
            blmitemsremaining = 0
        elsif blm.total_count < numberOfPage
            blmitemsremaining = blm.total_count 
        else
            blmitemsremaining = blm.total_count - (params[:page].to_i * numberOfPage)
        end

        memorial = Memorial.near([lat,lon], 50)
        
        memorial = memorial.page(params[:page]).per(numberOfPage)
        if memorial.total_count == 0 || (memorial.total_count - (params[:page].to_i * numberOfPage)) < 0
            memorialitemsremaining = 0
        elsif memorial.total_count < numberOfPage
            memorialitemsremaining = memorial.total 
        else
            memorialitemsremaining = memorial.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {
            blmItemsRemaining: blmitemsremaining,
            blm: ActiveModel::SerializableResource.new(
                    blm, 
                    each_serializer: BlmSerializer
                ),
            memorialItemsRemaining: memorialitemsremaining,
            memorial: ActiveModel::SerializableResource.new(
                memorial, 
                    each_serializer: MemorialSerializer
                )
        }
    end
end
