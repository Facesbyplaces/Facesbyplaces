module Searchable
    include ApplicationConcern
  
    def set_posts
        postsId = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Post').pluck('searchable_id')
        posts = Post.where(id: postsId)
        @posts = posts.page(params[:page]).per(numberOfPage)
    end

    def set_memorials
        # search only blm memorials as implemented from mockup
        memorials = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Blm')

        # if user().account_type == 1
        #     memorials = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Blm')
        # else
        #     memorials = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Memorial')
        # end
        
        @memorials = memorials.page(params[:page]).per(numberOfPage)
    end

    def set_users
        users = PgSearch.multisearch(params[:keywords]).where(searchable_type: ['AlmUser', 'User']).map{|searchObject| 
            if searchObject.searchable_type == 'User'
                User.find(searchObject.searchable_id)
            else
                AlmUser.find(searchObject.searchable_id)
            end
        }.flatten.uniq

        @users = Kaminari.paginate_array(users).page(params[:page]).per(numberOfPage)
    end

    def set_followers 
        # get the followers of the page (users are the followers of the page)
        followers = PgSearch.multisearch(params[:keywords]).where(searchable_type: ['AlmUser', 'User']).map{|searchObject| 
            if searchObject.searchable.followers.where(page: @page).first
                if searchObject.searchable_type == 'User'
                    User.find(searchObject.searchable_id)
                else
                    AlmUser.find(searchObject.searchable_id)
                end
            else
                []
            end
        }.flatten.uniq

        @followers = Kaminari.paginate_array(followers).page(params[:page]).per(numberOfPage)
    end

    def set_nearby_alms
        lon = params[:longitude].to_f
        lat = params[:latitude].to_f

        user_location = Geocoder.search([lat,lon])
        # get account type
        account
        
        memorial_pages_owned = Pageowner.where(account: user()).first ? Pageowner.where(account: user(), page_type: 'Memorial').pluck('page_id') : []
        memorial = Memorial.where.not(id: memorial_pages_owned).near([lat,lon], 50)
        
        @memorials = memorial.page(params[:page]).per(numberOfPage)
    end
    
    def set_nearby_blms
        lon = params[:longitude].to_f
        lat = params[:latitude].to_f

        user_location = Geocoder.search([lat,lon])
        # get account type
        account

        blm_pages_owned = Pageowner.where(account: user()).first ? Pageowner.where(account: user(), page_type: 'Blm').pluck('page_id') : []
        blm = Blm.where.not(id: blm_pages_owned).near([lat,lon], 50)
        
        @blms = blm.page(params[:page]).per(numberOfPage)
    end

    def set_suggested_pages
        # get all the pages in descending order based on their view count
        if user().guest == false
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
        else
            pages = Pageowner.all 
        end

        @pages = pages.page(params[:page]).per(numberOfPage)
    end

    def set_page
        case params[:page_type]
        when "Blm"
           @page = Blm.find(params[:page_id])
        when "Memorial"
           @page = Memorial.find(params[:page_id])
        end 
    end

    def account
        if user().account_type == 1
            return account = 'User'
        else
            return account = 'AlmUser'
        end
    end
end