module Userable
    include ApplicationConcern
    
    def set_user
        @user = params[:account_type].to_i == 1 ? User.find(params[:user_id]) : AlmUser.find(params[:user_id])
    end

    def set_searched_users
        users = PgSearch.multisearch(params[:keywords]).where(searchable_type: ['AlmUser', 'User']).map{|searchObject| 
            if searchObject.searchable_type == 'User'
                User.find(searchObject.searchable_id)
            else
                AlmUser.find(searchObject.searchable_id)
            end
        }.flatten.uniq

        @users = Kaminari.paginate_array(users).page(params[:page]).per(numberOfPage)
    end

    def set_users
        blm_users = User.all.where.not(guest: true, username: "admin").order("users.id DESC")
        alm_users = AlmUser.all.order("alm_users.id DESC")

        # BLM Users
        @blm_users = blm_users.page(params[:page]).per(numberOfPage)

        # ALM Users
        @alm_users = alm_users.page(params[:page]).per(numberOfPage)
    end

end