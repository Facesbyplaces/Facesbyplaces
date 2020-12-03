class Api::V1::Mainpages::MainpagesController < ApplicationController
    before_action :authenticate_user!

    # user's feed
    def feed
        posts = Post.joins("INNER JOIN #{pages_sql} ON pages.id = posts.page_id AND posts.page_type = pages.object_type")
                    .joins("INNER JOIN followers ON followers.user_id = #{user().id} AND followers.page_type = posts.page_type AND followers.page_id = posts.page_id OR posts.user_id = #{user().id}")
                    .order(created_at: :desc)
                    .select("posts.*")
        
        posts = posts.page(params[:page]).per(1)
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
            blmFamily = Blm.joins(:pageowner).where("pageowners.user_id = #{user().id}").joins(:relationships).where("relationships.relationship = 'Father' or relationships.relationship = 'Mother' or relationships.relationship = 'Brother' or relationships.relationship = 'Sister' or relationships.relationship = 'Uncle' or relationships.relationship = 'Aunt' or relationships.relationship = 'Grandmother' or relationships.relationship = 'Grandfather'")
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

            memorialFamily = Memorial.joins(:pageowner).where("pageowners.user_id = #{user().id}").joins(:relationships).where("relationships.relationship = 'Father' or relationships.relationship = 'Mother' or relationships.relationship = 'Brother' or relationships.relationship = 'Sister' or relationships.relationship = 'Uncle' or relationships.relationship = 'Aunt' or relationships.relationship = 'Grandmother' or relationships.relationship = 'Grandfather'")
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
            blmFriends = Blm.joins(:pageowner).where("pageowners.user_id = #{user().id}").joins(:relationships).where("relationships.relationship = 'Friend'")
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

            memorialFriends = Memorial.joins(:pageowner).where("pageowners.user_id = #{user().id}").joins(:relationships).where("relationships.relationship = 'Friend'")
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
                        notifs: notifs
                    }
    end
    
end
