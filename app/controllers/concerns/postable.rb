module Postable
    include ApplicationConcern
  
    # USER
    def set_posts
        posts = Post.where(account: user()).order(created_at: :desc)
        @posts = posts.page(params[:page]).per(numberOfPage)
    end

    def set_page_posts
        posts = Post.where(page_type: params[:page_type], page_id: params[:page_id]).order(created_at: :desc)
        @posts = posts.page(params[:page]).per(numberOfPage)
    end

    def set_pages
        if user().account_type == 1
            pagesId = user().roles.select('resource_id')

            @pages = pagesId.collect do |page|
                page = Blm.find(page.resource_id)

                ActiveModel::SerializableResource.new(
                    page, 
                    each_serializer: BlmSerializer
                )
    
            rescue ActiveRecord::RecordNotFound                    
                page = Blm.find(page.resource_id - 1)

                ActiveModel::SerializableResource.new(
                    page, 
                    each_serializer: BlmSerializer
                )
            end
        else
            pagesId = user().roles.select('resource_id')

            @pages = pagesId.collect do |page|
                page = Memorial.find(page.resource_id)
                ActiveModel::SerializableResource.new(
                    page, 
                    each_serializer: MemorialSerializer
                )
            end
        end
    end

    # also used in admin
    def set_post
        @post = Post.find(params[:id])
    end

    def set_page
        case params[:post][:page_type] 
        when "Blm"
            @page = Blm.find(params[:post][:page_id])
        when "Memorial"
            @page = Memorial.find(params[:post][:page_id])
        end
    end

    # ADMIN
    def set_memorials
        @memorials = []
        if params[:account_type].to_i == 1
            User.find(params[:user_id]).roles.map{ |role|
                @memorials << role.resource
            }
        elsif params[:account_type].to_i == 2
            AlmUser.find(params[:user_id]).roles.map{ |role|
                @memorials << role.resource
            }
        end

        @memorials
    end

    def set_pageadmins
        @pageadmins = []
        users = User.all.where.not(guest: true, username: "admin").order("users.id DESC")
        alm_users = AlmUser.all.order("alm_users.id DESC")
        allUsers = users + alm_users

        allUsers.map{ |user| 
            @pageadmins << user unless user.roles.empty?
        }
        @pageadmins
    end

    def set_posts
        posts = Post.all.order("posts.id DESC")
        @posts = posts.page(params[:page]).per(numberOfPage)
    end

    def set_alm_posts
        alm_posts = @posts.where(page_type: "Memorial")
        @alm_posts = alm_posts.page(params[:page]).per(numberOfPage)
    end

    def set_blm_posts
        blm_posts = @posts.where(page_type: "Blm")
        @blm_posts = blm_posts.page(params[:page]).per(numberOfPage)
    end

    def set_searched_posts
        postsId = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Post').pluck('searchable_id')
        @posts = Post.where(id: postsId)
    end

    def set_user
        if params[:account_type].to_i === 1
            @user = User.find(params[:user_id])
        elsif params[:account_type].to_i === 2
            @user = AlmUser.find(params[:user_id])
        end
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