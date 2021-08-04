module Blmable
    include ApplicationConcern

    def set_blm
        @blm = Blm.find(params[:id])
    end

    def set_families
        @families = @blm.relationships.where("relationship != 'Friend'").page(params[:page]).per(numberOfPage)
    end

    def set_friends
        @friends = @blm.relationships.where(relationship: 'Friend').page(params[:page]).per(numberOfPage)
    end

    def set_followers
        blmFollowersRaw = Follower.where(page_type: 'Blm', page_id: params[:id]).map{|follower| follower.account}
        @followers = Kaminari.paginate_array(blmFollowersRaw).page(params[:page]).per(numberOfPage)
    end

    def set_admins
        admins = Relationship.where(page_type: 'Blm', page_id: params[:page_id], account_type: 'User', account_id: @adminsRaw)
        @admins = admins.page(params[:page]).per(numberOfPage)
    end

    def set_family_admins
        familyRaw = Blm.find(params[:page_id]).relationships.where("relationship != 'Friend' AND account_type = 'User' AND account_id NOT IN (?)", @adminsRaw)
        @family_admins = familyRaw.page(params[:page]).per(numberOfPage)
    end

    def set_adminsRaw
        @adminsRaw = Blm.find(params[:page_id] || params[:id]).roles.first.users.pluck('id')
    end
end