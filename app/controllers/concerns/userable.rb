module Userable
    include ApplicationConcern
  
    def set_user
        @user = params[:account_type] === "1" ? User.find(params[:user_id]) : AlmUser.find(params[:user_id])
    end
end