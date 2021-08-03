module Postable
    include ApplicationConcern
  
    def set_posts
        posts = Post.where(account: user()).order(created_at: :desc)
        @posts = posts.page(params[:page]).per(numberOfPage)
    end

    def set_page_posts
        posts = Post.where(page_type: params[:page_type], page_id: params[:page_id]).order(created_at: :desc)
        @posts = posts.page(params[:page]).per(numberOfPage)
    end

    def set_post
        @post = Post.find(params[:id])
    end

    def set_page
        case params[:post][:page_type]
        when "Blm"
            @page = Blm.find(params[:post][:page_id])
        when "Memorial"
            @page = Memorial.find(params[:post][:page_id])
        end
    end
end