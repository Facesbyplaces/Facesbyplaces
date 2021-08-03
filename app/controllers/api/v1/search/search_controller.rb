class Api::V1::Search::SearchController < ApplicationController
    before_action :authenticate_user, only: [:nearby, :suggested, :test]
    before_action :set_posts, only: [:posts]
    before_action :set_memorials, only: [:memorials]
    before_action :set_users, only: [:users]
    before_action :set_followers, only: [:followers]
    before_action :set_nearby_alms, only: [:nearby]
    before_action :set_nearby_blms, only: [:nearby]
    before_action :set_suggested_pages, only: [:suggested]

    def posts
        render json: {  itemsremaining:  itemsRemaining(@posts),
                        posts: ActiveModel::SerializableResource.new(
                            @posts, 
                            each_serializer: PostSerializer
                        )
                    }
    end

    def memorials
        render json: {  itemsremaining:  itemsRemaining(@memorials),
                        memorials: ActiveModel::SerializableResource.new(
                                    @memorials, 
                                    each_serializer: SearchmemorialSerializer
                                )
                    }
    end

    def users
        render json: {  itemsremaining:  itemsRemaining(@users),
                        users: ActiveModel::SerializableResource.new(
                            @users, 
                            each_serializer: UserSerializer
                        )
                    }
    end

    def followers
        render json: {  itemsremaining:  itemsRemaining(@followers),
                        followers: ActiveModel::SerializableResource.new(
                            @followers, 
                            each_serializer: UserSerializer
                        )
                    }
    end

    def nearby
        render json: {
            blmItemsRemaining: itemsRemaining(@blms),
            blm: ActiveModel::SerializableResource.new(
                    @blms, 
                    each_serializer: BlmSerializer
                ),
            memorialItemsRemaining: itemsRemaining(@memorials),
            memorial: ActiveModel::SerializableResource.new(
                    @memorials, 
                    each_serializer: MemorialSerializer
                )
        }
    end

    def suggested
        render json: {
            itemsRemaining: itemsRemaining(@pages),
            pages: ActiveModel::SerializableResource.new(
                        @pages, 
                        each_serializer: PageownerSerializer
                    )
        }
    end

    def test
        render json: {user: user().first_name, type: user().account_type}
    end

    private

    def fetched_page
        case params[:page_type]
        when "Blm"
           return page = Blm.find(params[:page_id])
        when "Memorial"
           return page = Memorial.find(params[:page_id])
        end 
    end

    def user_location
        lon = params[:longitude].to_f
        lat = params[:latitude].to_f

        return user_location = Geocoder.search([lat,lon])
    end

    def account
        if user().account_type == 1
            return account = 'User'
        else
            return account = 'AlmUser'
        end
    end

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
            if searchObject.searchable.followers.where(page: fetched_page).first
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

    def itemsRemaining(data)
        if data.total_count == 0 || (data.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif data.total_count < numberOfPage
            itemsremaining = data.total_count 
        else
            itemsremaining = data.total_count - (params[:page].to_i * numberOfPage)
        end
    end
end
