module GuestHelper

    def create_guest
        session[:guest_user_id] = save_guest.id
    end

    def save_guest
        user = User.create(:username => "guest", :password => "guest")
        user.save(:validate => false)
        user
    end

    def guest_user
        User.find(session[:guest_user_id]) if session[:guest_user_id]
    end

    def guest?
        !!guest_user
    end
end