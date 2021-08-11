module Almable
    include ApplicationConcern 

    def set_memorial
        @memorial = Memorial.find(params[:id])
    end

    def set_families
        @families = @memorial.relationships.where("relationship != 'Friend'").page(params[:page]).per(numberOfPage)
    end

    def set_friends
        @friends = @memorial.relationships.where(relationship: 'Friend').page(params[:page]).per(numberOfPage)
    end

    def set_followers
        memorialFollowers = Follower.where(page_type: 'Memorial', page_id: params[:id]).map{|follower| follower.account}
        @followers = Kaminari.paginate_array(memorialFollowers).page(params[:page]).per(numberOfPage)
    end

    def set_admins
        admins = Relationship.where(page_type: 'Memorial', page_id: params[:page_id], account_type: 'AlmUser', account_id: @adminsRaw)
        @admins = admins.page(params[:page]).per(numberOfPage)
    end

    def set_family_admins
        familyRaw = Memorial.find(params[:page_id]).relationships.where("relationship != 'Friend' AND account_type = 'AlmUser' AND account_id NOT IN (?)", @adminsRaw)
        @family_admins = familyRaw.page(params[:page]).per(numberOfPage)
    end

    def set_adminsRaw
        @adminsRaw = AlmRole.where(resource_type: 'Memorial', resource_id: params[:page_id]).joins("INNER JOIN alm_users_alm_roles ON alm_roles.id = alm_users_alm_roles.alm_role_id").pluck("alm_users_alm_roles.alm_user_id")
    end

    def add_view_count
        page = Pageowner.where(page_type: 'Memorial', page_id: @memorial.id).first
        return render json: {errors: "Page not found"}, status: 400 unless page != nil
        
        if page.view == nil
            page.update(view: 1)
        else
            page.update(view: (page.view + 1))
        end
    end

    def itemsRemaining(item)
        if item.total_count == 0 || (item.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif item.total_count < numberOfPage
            itemsremaining = item.total_count 
        else
            itemsremaining = item.total_count - (params[:page].to_i * numberOfPage)
        end
    end


end