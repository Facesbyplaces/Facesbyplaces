class Api::V1::Mainpages::MainpagesController < ApplicationController
    before_action :authenticate_user!

    # user's feed
    def feed
        posts = Post.joins("INNER JOIN #{pages_sql} ON pages.id = posts.page_id AND posts.page_type = pages.object_type INNER JOIN #{relationship_sql} ON relationship.user_id = #{user().id} AND relationship.page_type = pages.object_type AND relationship.page_id = pages.id")
                    .order(created_at: :desc)
                    .select("posts.*")

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

    # user's memorials
    def memorials
        # Family
            # BLM
            blmFamily = user().relationships.where("relationship != 'Friend' AND page_type = 'Blm'").pluck('page_id')
            blmFamily = Blm.where(id: blmFamily).order(created_at: :desc)
            blmFamily = blmFamily.page(params[:page]).per(numberOfPage)

            if blmFamily.total_count == 0 || (blmFamily.total_count - (params[:page].to_i * numberOfPage)) < 0
                blmFamilyItemsRemaining = 0
            elsif blmFamily.total_count < numberOfPage
                blmFamilyItemsRemaining = blmFamily.total_count 
            else
                blmFamilyItemsRemaining = blmFamily.total_count - (params[:page].to_i * numberOfPage)
            end

            blmFamily = ActiveModel::SerializableResource.new(
                            blmFamily, 
                            each_serializer: BlmSerializer
                        )
            # ===========================================================================================================
            # MEMORIAL
            memorialFamily = user().relationships.where("relationship != 'Friend' AND page_type = 'Memorial'").pluck('page_id')
            memorialFamily = Memorial.where(id: memorialFamily).order(created_at: :desc)
            memorialFamily = memorialFamily.page(params[:page]).per(numberOfPage)

            if memorialFamily.total_count == 0 || (memorialFamily.total_count - (params[:page].to_i * numberOfPage)) < 0
                memorialFamilyItemsRemaining = 0
            elsif memorialFamily.total_count < numberOfPage
                memorialFamilyItemsRemaining = memorialFamily.total 
            else
                memorialFamilyItemsRemaining = memorialFamily.total_count - (params[:page].to_i * numberOfPage)
            end

            memorialFamily = ActiveModel::SerializableResource.new(
                            memorialFamily, 
                            each_serializer: MemorialSerializer
                        )
                        
        # Friends
            # BLM
            blmFriends = user().relationships.where(relationship: 'Friend', page_type: 'Blm').pluck('page_id')
            blmFriends = Blm.where(id: blmFriends).order(created_at: :desc)
            blmFriends = blmFriends.page(params[:page]).per(numberOfPage)

            if blmFriends.total_count == 0 || (blmFriends.total_count - (params[:page].to_i * numberOfPage)) < 0
                blmFriendsItemsRemaining = 0
            elsif blmFriends.total_count < numberOfPage
                blmFriendsItemsRemaining = blmFriends.total 
            else
                blmFriendsItemsRemaining = blmFriends.total_count - (params[:page].to_i * numberOfPage)
            end
            
            blmFriends = ActiveModel::SerializableResource.new(
                            blmFriends, 
                            each_serializer: BlmSerializer
                        )
            
            # ===========================================================================================================
            # MEMORIAL
            memorialFriends = user().relationships.where(relationship: 'Friend', page_type: 'Memorial').pluck('page_id')
            memorialFriends = Memorial.where(id: memorialFriends).order(created_at: :desc)
            memorialFriends = memorialFriends.page(params[:page]).per(numberOfPage)

            if memorialFriends.total_count == 0 || (memorialFriends.total_count - (params[:page].to_i * numberOfPage)) < 0
                memorialFriendsItemsRemaining = 0
            elsif memorialFriends.total_count < numberOfPage
                memorialFriendsItemsRemaining = memorialFriends.total 
            else
                memorialFriendsItemsRemaining = memorialFriends.total_count - (params[:page].to_i * numberOfPage)
            end

            memorialFriends = ActiveModel::SerializableResource.new(
                                memorialFriends, 
                                each_serializer: MemorialSerializer
                            )

        render json: {
            family: {
                blmFamilyItemsRemaining: blmFamilyItemsRemaining,
                blm: blmFamily,
                memorialFamilyItemsRemaining: memorialFamilyItemsRemaining,
                memorial: memorialFamily
            }, 
            friends: {
                blmFriendsItemsRemaining: blmFriendsItemsRemaining,
                blm: blmFriends,
                memorialFriendsItemsRemaining: memorialFriendsItemsRemaining,
                memorial: memorialFriends
            }
        }
    end
    
    # user's posts
    def posts
        # Posts that they created or owned
        posts = Post.where(user: user()).order(created_at: :desc)
        
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

    # user's notifications
    def notifications
        notifs = user().notifications.order(created_at: :desc)
        
        notifs = notifs.page(params[:page]).per(numberOfPage)
        if notifs.total_count == 0 || (notifs.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif notifs.total_count < numberOfPage
            itemsremaining = notifs.total_count 
        else
            itemsremaining = notifs.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        notifs: ActiveModel::SerializableResource.new(
                                notifs, 
                                each_serializer: NotificationSerializer
                            )
                    }
    end
    
end
