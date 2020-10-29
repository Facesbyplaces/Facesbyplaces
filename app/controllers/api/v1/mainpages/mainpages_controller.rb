class Api::V1::Mainpages::MainpagesController < ApplicationController

    # user's feed
    def feed
        # posts of the memorial that they own
        posts = Post.where("user_id = #{user().id}")
        
        paginate posts, per_page: numberOfPage
    end

    # user's memorials
    def memorials
        # Family
        family = Relationship.where(user: user()).where("relationship = 'Brother' or relationship = 'Sister' or relationship = 'Father' or relationship = 'Mother' or relationship = 'Uncle' or relationship = 'Family'")
        family = ActiveModel::SerializableResource.new(
                    family, 
                    each_serializer: RelationshipSerializer
                )

        # Friends
        friends = Relationship.where(user: user()).where("relationship = 'Friends'")
        friends = ActiveModel::SerializableResource.new(
                friends, 
                    each_serializer: RelationshipSerializer
                )

        render json: {
            family: family, 
            friends: friends
        }
    end

    # user's posts
    def posts
        # Posts that they created or owned
        posts = Post.where(user: user())
        
        paginate posts, per_page: numberOfPage
    end
end
