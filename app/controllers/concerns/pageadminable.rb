module Pageadminable
    include ApplicationConcern
    
    def set_page
        case params[:page_type]
        when "Blm"
            @page = Blm.find(params[:page_id])
        when "Memorial"
            @page = Memorial.find(params[:page_id])
        end
    end

    def set_user
        if params[:account_type] == "1"
            @user = User.find(params[:user_id])
        else
            @user = AlmUser.find(params[:user_id])
        end
    end

    def set_post
        @post = Post.find(params[:post_id])
    end

end