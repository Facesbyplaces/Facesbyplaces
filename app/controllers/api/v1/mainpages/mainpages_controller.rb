class Api::V1::Mainpages::MainpagesController < ApplicationController
    include Mainpageable
    before_action :authenticate_user
    before_action :set_posts, only: [:posts]
    before_action :set_feeds, only: [:feed]
    before_action :set_notifs, only: [:notifications]
    before_action :set_blmFamilies, :set_blmFriends, :set_memorialFamilies, :set_memorialFriends, only: [:memorials]

    def feed
        render json: {  itemsremaining:  itemsRemaining(@posts),
                        posts: ActiveModel::SerializableResource.new(
                            @posts, 
                            each_serializer: PostSerializer
                        )
                    }
    end
    
    def posts
        render json: {  itemsremaining:  itemsRemaining(@posts),
                        posts: ActiveModel::SerializableResource.new(
                            @posts, 
                            each_serializer: PostSerializer
                        )
                    }
    end

    def notifications
        render json: {  itemsremaining:  itemsRemaining(@notifs),
                        notifs: ActiveModel::SerializableResource.new(
                                @notifs, 
                                each_serializer: NotificationSerializer
                            )
                    }
    end

    def memorials
        render json: {
            family: {
                blmFamilyItemsRemaining: itemsRemaining(@blmFamily),
                blm: blmFamily = ActiveModel::SerializableResource.new(
                                    @blmFamily, 
                                    each_serializer: BlmSerializer
                                ),
                memorialFamilyItemsRemaining: itemsRemaining(@memorialFamily),
                memorial: memorialFamily = ActiveModel::SerializableResource.new(
                                                @memorialFamily, 
                                                each_serializer: MemorialSerializer
                                            )
            }, 
            friends: {
                blmFriendsItemsRemaining: itemsRemaining(@blmFriends),
                blm: blmFriend = ActiveModel::SerializableResource.new(
                                    @blmFriends, 
                                    each_serializer: BlmSerializer
                                ),
                memorialFriendsItemsRemaining: itemsRemaining(@memorialFriends),
                memorial: memorialFriend = ActiveModel::SerializableResource.new(
                                                @memorialFriends, 
                                                each_serializer: MemorialSerializer
                                            )
            }
        }
    end
    
end
