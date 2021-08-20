class Posts::Unlike

    def initialize( user:, post: )
        @user   = user
        @post   = post
    end

    def execute
        if Postslike.where(account: @user, post_id: @post).first != nil
            unlike = Postslike.where(account: @user, post_id: @post).first
            if unlike.destroy 
                return true
            else
                return unlike.errors
            end
        else
            return "Already unliked the post"
        end
    end
 
end