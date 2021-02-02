class Api::V1::Admin::AdminController < ApplicationController
    before_action :check_user
    before_action :admin_only

    def allUsers
        users = User.all 
        alm_users = AlmUser.all

        # BLM Users
        users = users.page(params[:page]).per(numberOfPage)
        if users.total_count == 0 || (users.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif users.total_count < numberOfPage
            itemsremaining = users.total 
        else
            itemsremaining = users.total_count - (params[:page].to_i * numberOfPage)
        end

        # ALM Users
        alm_users = alm_users.page(params[:page]).per(numberOfPage)
        if alm_users.total_count == 0 || (alm_users.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif alm_users.total_count < numberOfPage
            itemsremaining = alm_users.total 
        else
            itemsremaining = alm_users.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        blm_users: ActiveModel::SerializableResource.new(
                                    users, 
                                    each_serializer: UserSerializer
                                ),
                        alm_users: ActiveModel::SerializableResource.new(
                                    alm_users, 
                                    each_serializer: UserSerializer
                        )
                    }
    end

    def showBlmUser
        user = User.find(params[:id]) 

        render json: ActiveModel::SerializableResource.new(
                        user, 
                        each_serializer: UserSerializer
                    )
    end

    def showAlmUser
        user = AlmUser.find(params[:id]) 

        render json: ActiveModel::SerializableResource.new(
                        user, 
                        each_serializer: UserSerializer
                    )
    end

    def searchBlmUser
        users = User.where('username LIKE :search or email LIKE :search or first_name LIKE :search or last_name LIKE :search', search: params[:keywords])

        users = users.page(params[:page]).per(numberOfPage)
        if users.total_count == 0 || (users.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif users.total_count < numberOfPage
            itemsremaining = users.total 
        else
            itemsremaining = users.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        users: ActiveModel::SerializableResource.new(
                                    users, 
                                    each_serializer: UserSerializer
                                )
                    }
    end

    def searchAlmUser
        users = AlmUser.where('username LIKE :search or email LIKE :search or first_name LIKE :search or last_name LIKE :search', search: params[:keywords])

        users = users.page(params[:page]).per(numberOfPage)
        if users.total_count == 0 || (users.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif users.total_count < numberOfPage
            itemsremaining = users.total 
        else
            itemsremaining = users.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        users: ActiveModel::SerializableResource.new(
                                    users, 
                                    each_serializer: UserSerializer
                                )
                    }
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
        postsId = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Post').pluck('searchable_id')

        posts = Post.where(id: postsId)
        
        posts = posts.page(params[:page]).per(numberOfPage)
        if posts.total_count == 0 || (posts.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif posts.total_count < numberOfPage
            itemsremaining = posts.total_count 
        else
            itemsremaining = posts.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        posts: ActiveModel::SerializableResource.new(
                            posts, 
                            each_serializer: PostSerializer
                        )
                    }
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
        memorials = PgSearch.multisearch(params[:keywords]).where(searchable_type: ['Memorial', 'Blm'])
        
        memorials = memorials.page(params[:page]).per(numberOfPage)
        if memorials.total_count == 0 || (memorials.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif memorials.total_count < numberOfPage
            itemsremaining = memorials.total_count 
        else
            itemsremaining = memorials.total_count - (params[:page].to_i * numberOfPage)
        end

        memorials = memorials.collect do |memorial|
            if memorial.searchable_type == 'Blm'
                memorial = Blm.find(memorial.searchable_id)
                ActiveModel::SerializableResource.new(
                    memorial, 
                    each_serializer: BlmSerializer
                )
            else
                memorial = Memorial.find(memorial.searchable_id)
                ActiveModel::SerializableResource.new(
                    memorial, 
                    each_serializer: MemorialSerializer
                )
            end
        end

        render json: {  itemsremaining:  itemsremaining,
                        memorials: memorials
                    }
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
                            
        reports = reports.page(params[:page]).per(numberOfPage)
        if reports.total_count == 0 || (reports.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif reports.total_count < numberOfPage
            itemsremaining = reports.total_count 
        else
            itemsremaining = reports.total_count - (params[:page].to_i * numberOfPage)
        end

        render json: {  itemsremaining:  itemsremaining,
                        reports: reports
                    }
    end

    def showReport
        report = Report.find(params[:id])

        render json: report
    end

    def transactions
        transactions = Transaction.where(page_type: params[:page_type], page_id: params[:page_id])

        render json: transactions
    end

    def show_transaction
        transaction = Transaction.find(params[:transaction_id])

        render json: transaction
    end

    private
    def admin_only
        if !user().has_role? :admin 
            return render json: {}, status: 401
        end
    end
end
