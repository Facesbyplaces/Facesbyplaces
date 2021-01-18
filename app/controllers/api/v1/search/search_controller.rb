class Api::V1::Search::SearchController < ApplicationController
    before_action :check_user, only: [:nearby, :suggested, :test]

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
        if user().account_type == 1
            memorials = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Blm')
        else
            memorials = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Memorial')
        end
        
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
                                    each_serializer: SearchmemorialSerializer
                                )
                    }
    end

    def users
        users = PgSearch.multisearch(params[:keywords]).where(searchable_type: ['AlmUser', 'User']).map{|searchObject| 
            if searchObject.searchable_type == 'User'
                User.find(searchObject.searchable_id)
            else
                AlmUser.find(searchObject.searchable_id)
            end
        }.flatten.uniq

        users = Kaminari.paginate_array(users).page(params[:page]).per(numberOfPage)
        if users.total_count == 0 || (users.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif users.total_count < numberOfPage
            itemsremaining = users.total_count 
        else
            itemsremaining = users.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        users: ActiveModel::SerializableResource.new(
                            users, 
                            each_serializer: UserSerializer
                        )
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
        followers = PgSearch.multisearch(params[:keywords]).where(searchable_type: ['AlmUser', 'User']).map{|searchObject| 
            if searchObject.searchable.followers.where(page: page).first
                if searchObject.searchable_type == 'User'
                    User.find(searchObject.searchable_id)
                else
                    AlmUser.find(searchObject.searchable_id)
                end
            else
                []
            end
        }.flatten.uniq

        followers = Kaminari.paginate_array(followers).page(params[:page]).per(numberOfPage)
        if followers.total_count == 0 || (followers.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif followers.total_count < numberOfPage
            itemsremaining = followers.total_count 
        else
            itemsremaining = followers.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        followers: ActiveModel::SerializableResource.new(
                            followers, 
                            each_serializer: UserSerializer
                        )
                    }
    end

    def nearby
        lon = params[:longitude].to_f
        lat = params[:latitude].to_f

        user_location = Geocoder.search([lat,lon])

        if user().account_type == 1
            account = 'User'
        else
            account = 'AlmUser'
        end

        blm = Blm.joins(:pageowner).where("pageowners.account_id != #{user().id} AND pageowners.account_type != '#{account}'").near([lat,lon], 50)
        
        blm = blm.page(params[:page]).per(numberOfPage)
        if blm.total_count == 0 || (blm.total_count - (params[:page].to_i * numberOfPage)) < 0
            blmitemsremaining = 0
        elsif blm.total_count < numberOfPage
            blmitemsremaining = blm.total_count 
        else
            blmitemsremaining = blm.total_count - (params[:page].to_i * numberOfPage)
        end

        memorial = Memorial.joins(:pageowner).where("pageowners.account_id != #{user().id} AND pageowners.account_type != '#{account}'").near([lat,lon], 50)
        
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

    def test
        render json: {user: user().first_name, type: user().account_type}
    end
end
