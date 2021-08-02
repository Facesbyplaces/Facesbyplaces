class Api::V1::Mainpages::MainpagesController < ApplicationController
    include Postable
    before_action :authenticate_user
    before_action :set_posts

    # user's feed
    def feed
        render json: {  itemsremaining:  itemsRemaining(postsFeed),
                        posts: ActiveModel::SerializableResource.new(
                            postsFeed, 
                            each_serializer: PostSerializer
                        )
                    }
    end
    
    # user's posts
    def posts
        render json: {  itemsremaining:  itemsRemaining(@posts),
                        posts: ActiveModel::SerializableResource.new(
                            @posts, 
                            each_serializer: PostSerializer
                        )
                    }
    end

    # user's notifications
    def notifications
        render json: {  itemsremaining:  itemsRemaining(notifs),
                        notifs: ActiveModel::SerializableResource.new(
                                notifs, 
                                each_serializer: NotificationSerializer
                            )
                    }
    end

    # user's memorials
    def memorials
        render json: {
            family: {
                blmFamilyItemsRemaining: itemsRemaining(blmFamilies),
                blm: blmFamily = ActiveModel::SerializableResource.new(
                                    blmFamilies, 
                                    each_serializer: BlmSerializer
                                ),
                memorialFamilyItemsRemaining: itemsRemaining(memorialFamilies),
                memorial: memorialFamily = ActiveModel::SerializableResource.new(
                                                memorialFamilies, 
                                                each_serializer: MemorialSerializer
                                            )
            }, 
            friends: {
                blmFriendsItemsRemaining: itemsRemaining(blmFriends),
                blm: blmFriend = ActiveModel::SerializableResource.new(
                                    blmFriends, 
                                    each_serializer: BlmSerializer
                                ),
                memorialFriendsItemsRemaining: itemsRemaining(memorialFriends),
                memorial: memorialFriend = ActiveModel::SerializableResource.new(
                                                memorialFriends, 
                                                each_serializer: MemorialSerializer
                                            )
            }
        }
    end

    private

    def account
        if user().account_type == 1
           return account = 'User'
        else
           return account = 'AlmUser'
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

    def postsFeed
        posts = Post.joins("INNER JOIN #{pages_sql} ON pages.id = posts.page_id AND posts.page_type = pages.object_type INNER JOIN #{relationship_sql} ON relationship.account_id = #{user().id} AND relationship.account_type = '#{account}' AND relationship.page_type = pages.object_type AND relationship.page_id = pages.id")
                    .order(created_at: :desc)
                    .select("posts.*")

        return posts.page(params[:page]).per(numberOfPage)
    end

    def notifs
        notifs = user().notifications.order(created_at: :desc)
        return notifs.page(params[:page]).per(numberOfPage)
    end

    def blmFamilies
        blmFamily = user().relationships.where("relationship != 'Friend' AND page_type = 'Blm'").pluck('page_id')
        blmFamily = Blm.where(id: blmFamily).order(created_at: :desc)
        return blmFamily.page(params[:page]).per(numberOfPage)
    end

    def blmFriends
        blmFriends = user().relationships.where(relationship: 'Friend', page_type: 'Blm').pluck('page_id')
        blmFriends = Blm.where(id: blmFriends).order(created_at: :desc)
        return blmFriends.page(params[:page]).per(numberOfPage)
    end

    def memorialFamilies
        memorialFamily = user().relationships.where("relationship != 'Friend' AND page_type = 'Memorial'").pluck('page_id')
        memorialFamily = Memorial.where(id: memorialFamily).order(created_at: :desc)
        return memorialFamily.page(params[:page]).per(numberOfPage)
    end
    
    def memorialFriends
        memorialFriends = user().relationships.where(relationship: 'Friend', page_type: 'Memorial').pluck('page_id')
        memorialFriends = Memorial.where(id: memorialFriends).order(created_at: :desc)
        return memorialFriends.page(params[:page]).per(numberOfPage)
    end
    
end
