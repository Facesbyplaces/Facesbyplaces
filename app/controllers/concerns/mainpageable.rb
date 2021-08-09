module Mainpageable
    include ApplicationConcern
    
    def set_feeds
        posts = Post.joins("INNER JOIN #{pages_sql} ON pages.id = posts.page_id AND posts.page_type = pages.object_type INNER JOIN #{relationship_sql} ON relationship.account_id = #{user().id} AND relationship.account_type = '#{account}' AND relationship.page_type = pages.object_type AND relationship.page_id = pages.id")
                    .order(created_at: :desc)
                    .select("posts.*")

        @posts = posts.page(params[:page]).per(numberOfPage)
    end
    
    def set_posts
        posts = Post.where(account: user()).order(created_at: :desc)
        @posts = posts.page(params[:page]).per(numberOfPage)
    end

    def set_notifs
        notifs = user().notifications.order(created_at: :desc)
        @notifs = notifs.page(params[:page]).per(numberOfPage)
    end

    def set_blmFamilies
        blmFamily = user().relationships.where("relationship != 'Friend' AND page_type = 'Blm'").pluck('page_id')
        blmFamily = Blm.where(id: blmFamily).order(created_at: :desc)
        @blmFamily = blmFamily.page(params[:page]).per(numberOfPage)
    end

    def set_blmFriends
        blmFriends = user().relationships.where(relationship: 'Friend', page_type: 'Blm').pluck('page_id')
        blmFriends = Blm.where(id: blmFriends).order(created_at: :desc)
        @blmFriends = blmFriends.page(params[:page]).per(numberOfPage)
    end

    def set_memorialFamilies
        memorialFamily = user().relationships.where("relationship != 'Friend' AND page_type = 'Memorial'").pluck('page_id')
        memorialFamily = Memorial.where(id: memorialFamily).order(created_at: :desc)
        @memorialFamily = memorialFamily.page(params[:page]).per(numberOfPage)
    end
    
    def set_memorialFriends
        memorialFriends = user().relationships.where(relationship: 'Friend', page_type: 'Memorial').pluck('page_id')
        memorialFriends = Memorial.where(id: memorialFriends).order(created_at: :desc)
        @memorialFriends = memorialFriends.page(params[:page]).per(numberOfPage)
    end
    
    def account
        if user().account_type == 1
           return 'User'
        else
           return 'AlmUser'
        end
    end

    def itemsRemaining(data)
        if data.total_count == 0 || (data.total_count - (params[:page].to_i * numberOfPage)) < 0
            return 0
        elsif data.total_count < numberOfPage
            return data.total_count 
        else
            return data.total_count - (params[:page].to_i * numberOfPage)
        end
    end


end