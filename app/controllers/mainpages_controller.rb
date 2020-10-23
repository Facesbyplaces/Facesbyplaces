class MainpagesController < ApplicationController

    # user's feed
    def feed
        # posts of the memorial that they own
        posts = Post.joins(:memorial).where("memorials.user_id = #{user_id()}")
        
        paginate posts, per_page: numberOfPage
    end

    # user's memorials
    def memorials
        # Family memorials
        memorialsFamily = Memorial.where(user_id: user_id()).joins(:memorialUserRelationships).where("memorial_user_relationships.relationship = 'Brother'")

        # Friends memorials
        memorialsFriends = Memorial.where(user_id: user_id()).joins(:memorialUserRelationships).where("memorial_user_relationships.relationship = 'Friends'")
        
        render json: {
            family: ActiveModel::SerializableResource.new(
                        memorialsFamily, 
                        each_serializer: MemorialSerializer
                    ), 
            friends: ActiveModel::SerializableResource.new(
                        memorialsFriends, 
                        each_serializer: MemorialSerializer
                    )
        }
    end

    # user's posts
    def posts
        # Posts that they created or owned
        posts = Post.where(user_id: user_id())
        
        paginate posts, per_page: numberOfPage
    end
end
