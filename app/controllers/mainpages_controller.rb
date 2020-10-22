class MainpagesController < ApplicationController

    # user's feed
    def feed
        # posts of the memorial that they own
        posts = Post.joins(:memorial).where("memorials.user_id = #{user_id()}")
        
        paginate posts, per_page: numberOfPage
    end

    # user's memorials
    def memorials
        # memorials they own
        memorials = Memorial.where(user_id: user_id())

        paginate memorials, per_page: numberOfPage
    end

    # user's posts
    def posts
        # Posts that they created or owned
        posts = Post.where(user_id: user_id())
        
        paginate posts, per_page: numberOfPage
    end
end
