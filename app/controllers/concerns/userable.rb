module Userable
    include ApplicationConcern
  
    def set_user
        if params[:account_type] == "1"
            @user = User.find(params[:user_id])
        else
            @user = AlmUser.find(params[:user_id])
        end
    end
end