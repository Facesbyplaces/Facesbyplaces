class Api::V1::Mainpages::MainpagesController < ApplicationController

    # user's feed
    def feed
        posts = Post.joins("INNER JOIN #{pages_sql} ON pages.id = posts.page_id AND posts.page_type = pages.object_type")
                    .joins("INNER JOIN followers ON followers.user_id = #{user().id} AND followers.page_type = posts.page_type AND followers.page_id = posts.page_id")
                    .order(created_at: :desc)
                    .select("posts.*")
        
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
        posts = Post.where(user: user()).order(created_at: :desc)
        
        paginate posts, per_page: numberOfPage
    end

    # user's notifications
    def notifications
        notifs = user().notifications.order(created_at: :desc)

        paginate notifs, per_page: numberOfPage
    end
    
end
