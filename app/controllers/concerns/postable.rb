module Postable
    include ApplicationConcern
  
    def set_posts
        posts = Post.where(account: user()).order(created_at: :desc)
        @posts = posts.page(params[:page]).per(numberOfPage)
    end
end