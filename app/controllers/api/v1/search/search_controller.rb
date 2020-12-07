class Api::V1::Search::SearchController < ApplicationController
    def posts
        postsId = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Post').pluck('searchable_id')

        posts = Post.where(id: postsId)
        
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
        memorials = PgSearch.multisearch(params[:keywords]).where(searchable_type: ['Memorial', 'Blm'])
        
        memorials = memorials.page(params[:page]).per(numberOfPage)
        if memorials.total_count == 0 || (memorials.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif memorials.total_count < numberOfPage
            itemsremaining = memorials.total_count 
        else
            itemsremaining = memorials.total_count - (params[:page].to_i * numberOfPage)
        end

        memorials = memorials.collect do |memorial|
            if memorial.searchable_type == 'Blm'
                memorial = Blm.find(memorial.searchable_id)
                ActiveModel::SerializableResource.new(
                    memorial, 
                    each_serializer: BlmSerializer
                )
            else
                memorial = Memorial.find(memorial.searchable_id)
                ActiveModel::SerializableResource.new(
                    memorial, 
                    each_serializer: MemorialSerializer
                )
            end
        end

        render json: {  itemsremaining:  itemsremaining,
                        memorials: memorials
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

    def suggested
        # get all the pages in descending order based on their view count
        followers_page_type = user().followers.pluck("page_type")
        followers_page_id = user().followers.pluck("page_id")
        relationships_page_type = user().relationships.pluck("page_type")
        relationships_page_id = user().relationships.pluck("page_id")

        if followers_page_type.count != 0 && relationships_page_type.count != 0

            pages = Pageowner.where("page_type NOT IN (?) OR page_id NOT IN (?)", followers_page_type, followers_page_id)
                            .where("page_type NOT IN (?) OR page_id NOT IN (?)", relationships_page_type, relationships_page_id)
                            .order(view: :desc)

        elsif followers_page_type.count != 0

            pages = Pageowner.where("page_type NOT IN (?) OR page_id NOT IN (?)", followers_page_type, followers_page_id)
                            .order(view: :desc)

        elsif relationships_page_type.count != 0

            pages = Pageowner.where("page_type NOT IN (?) OR page_id NOT IN (?)", relationships_page_type, relationships_page_id)
                            .order(view: :desc)

        else
            pages = Pageowner.order(view: :desc)
        end

        pages = pages.page(params[:page]).per(numberOfPage)

        if pages.total_count == 0 || (pages.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsRemaining = 0
        elsif pages.total_count < numberOfPage
            itemsRemaining = pages.total_count 
        else
            itemsRemaining = pages.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {
            itemsRemaining: itemsRemaining,
            pages: ActiveModel::SerializableResource.new(
                        pages, 
                        each_serializer: PageownerSerializer
                    )
        }
    end
end
