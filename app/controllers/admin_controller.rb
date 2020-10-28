class AdminController < ApplicationController

    def allUsers
        users = User.all 

        paginate users, per_page: numberOfPage
    end

    def showUser
        user = User.find(params[:id])

        render json: user
    end

    def searchUser
        users = User.where('username LIKE :search or email LIKE :search or first_name LIKE :search or last_name LIKE :search', search: params[:keywords])

        render json: users
    end

    def contactUser
        message = params[:message]
        userEmail = User.find(params[:id]).email
        subject = params[:subject]

        ContactUserMailer.with(message: message, email: userEmail, subject: subject).contact_user.deliver_later

        render json: {status: "Email Sent"}
    end

    def showPost
        post = Post.find(params[:id])

        render json: post
    end

    def deletePost
        post = Post.find(params[:id])
        post.destroy 

        render json: {status: :deleted}
    end

    def searchPost
        posts = Post.joins(:memorial).where('memorials.name LIKE :search or memorials.country LIKE :search or memorials.cemetery LIKE :search or posts.body LIKE :search or posts.location LIKE :search', search: params[:keywords]).select('posts.*')

        paginate posts, per_page: numberOfPage
    end
    
    def showMemorial
        memorial = Pageowner.where(page_id: params[:id]).where(page_type: params[:page]).first

        if memorial
            if params[:page] == "Blm"
                render json: BlmSerializer.new( memorial.page ).attributes
            else
                render json: MemorialSerializer.new( memorial.page ).attributes
            end
        else
            render json: {errors: "Page not found"}
        end
    end

    def searchMemorial
        memorials = Memorial.where('name LIKE :search or country LIKE :search or cemetery LIKE :search', search: params[:keywords])
        
        paginate memorials, per_page: numberOfPage
    end

    def deleteMemorial
        memorial = Pageowner.where(page_id: params[:id]).where(page_type: params[:page]).first
        if memorial
            memorial.page.destroy 
            render json: {status: :deleted}
        else
            render json: {status: "page not found"}
        end
    end
end
