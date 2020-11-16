class Api::V1::Admin::AdminController < ApplicationController
    before_action :authenticate_user!
    before_action :admin_only

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
        posts = Post.joins("INNER JOIN #{pages_sql} ON pages.id = posts.page_id AND posts.page_type = pages.object_type")
                    .where("pages.name LIKE :search or pages.country LIKE :search or pages.description LIKE :search", search: params[:keywords])
                    .select("posts.*")
        
        paginate posts, per_page: numberOfPage
    end
    
    def showMemorial
        memorial = Pageowner.where(page_id: params[:id]).where(page_type: params[:page]).first

        if memorial
            render json: memorial
        else
            render json: {errors: "Page not found"}
        end
    end

    def searchMemorial
        memorials = Pageowner.joins("INNER JOIN #{pages_sql} ON pages.id = pageowners.page_id AND pageowners.page_type = pages.object_type")
                            .where("pages.name LIKE :search or pages.country LIKE :search or pages.description LIKE :search", search: params[:keywords])
                            
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

    def allReports
        reports = Report.all 

        paginate reports, per_page: numberOfPage
    end

    def showReport
        report = Report.find(params[:id])

        render json: report
    end

    private
    def admin_only
        if !user().has_role? :admin 
            return render json: {status: "Access Denied"}
        end
    end
end
