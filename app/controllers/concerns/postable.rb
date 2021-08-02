module Postable
    include ApplicationConcern
  
    def set_posts
        posts = Post.where(account: user())
        @posts = posts.page(params[:page]).per(numberOfPage)
    end
end