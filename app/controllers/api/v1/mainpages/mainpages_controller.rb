class Api::V1::Mainpages::MainpagesController < ApplicationController
    before_action :authenticate_user!

    # user's feed
    def feed
        posts = Post.joins("INNER JOIN #{pages_sql} ON pages.id = posts.page_id AND posts.page_type = pages.object_type")
                    .joins("INNER JOIN followers ON followers.user_id = #{user().id} AND followers.page_type = posts.page_type AND followers.page_id = posts.page_id OR posts.user_id = #{user().id}")
                    .order(created_at: :desc)
                    .select("posts.*")
        
        pagy =  pagy(posts)
        
        paginate posts, per_page: numberOfPage
    end

    # user's memorials
    def memorials
        # Family
            blmFamily = Blm.joins(:pageowner).where("pageowners.user_id = #{user().id}").joins(:relationships).where("relationships.relationship = 'Father' or relationships.relationship = 'Mother' or relationships.relationship = 'Brother' or relationships.relationship = 'Sister' or relationships.relationship = 'Uncle' or relationships.relationship = 'Aunt' or relationships.relationship = 'Grandmother' or relationships.relationship = 'Grandfather'")

            blmFamily = ActiveModel::SerializableResource.new(
                            blmFamily, 
                            each_serializer: BlmSerializer
                        )

            memorialFamily = Memorial.joins(:pageowner).where("pageowners.user_id = #{user().id}").joins(:relationships).where("relationships.relationship = 'Father' or relationships.relationship = 'Mother' or relationships.relationship = 'Brother' or relationships.relationship = 'Sister' or relationships.relationship = 'Uncle' or relationships.relationship = 'Aunt' or relationships.relationship = 'Grandmother' or relationships.relationship = 'Grandfather'")

            memorialFamily = ActiveModel::SerializableResource.new(
                            memorialFamily, 
                            each_serializer: MemorialSerializer
                        )
                        
        # Friends
            blmFriends = Blm.joins(:pageowner).where("pageowners.user_id = #{user().id}").joins(:relationships).where("relationships.relationship = 'Friend'")
            
            blmFriends = ActiveModel::SerializableResource.new(
                            blmFriends, 
                            each_serializer: BlmSerializer
                        )

            memorialFriends = Memorial.joins(:pageowner).where("pageowners.user_id = #{user().id}").joins(:relationships).where("relationships.relationship = 'Friend'")

            memorialFriends = ActiveModel::SerializableResource.new(
                                memorialFriends, 
                                each_serializer: MemorialSerializer
                            )

        render json: {
            family: {
                blm: blmFamily,
                memorial: memorialFamily
            }, 
            friends: {
                blm: blmFriends,
                memorial: memorialFriends
            }
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
