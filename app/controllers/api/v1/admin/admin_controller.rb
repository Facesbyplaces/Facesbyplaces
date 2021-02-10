class Api::V1::Admin::AdminController < ApplicationController
    before_action :check_user
    before_action :admin_only

    def allUsers
        users = User.all.where.not(guest: true, username: "admin")
        # _except(User.guest).order("users.id DESC")
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

        allUsers = users.order("users.id DESC") + alm_users.order("alm_users.id DESC")

        render json: {  itemsremaining:  itemsremaining,
                        users: ActiveModel::SerializableResource.new(
                                    allUsers, 
                                    each_serializer: UserSerializer
                                ),
                        user: user,
                    }
    end

    def showUser
        if params[:account_type] == '1'
            user = User.find(params[:id]) 
        else
            user = AlmUser.find(params[:id]) 
        end

        render json: ActiveModel::SerializableResource.new(
                        user, 
                        each_serializer: UserSerializer
                    )
    end

    # def searchBlmUser
    #     users = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'User').map{|searchObject| 
    #         User.find(searchObject.searchable_id)
    #     }.flatten.uniq

    #     users = Kaminari.paginate_array(users).page(params[:page]).per(numberOfPage)
    #     if users.total_count == 0 || (users.total_count - (params[:page].to_i * numberOfPage)) < 0
    #         itemsremaining = 0
    #     elsif users.total_count < numberOfPage
    #         itemsremaining = users.total 
    #     else
    #         itemsremaining = users.total_count - (params[:page].to_i * numberOfPage)
    #     end

    #     render json: {  itemsremaining:  itemsremaining,
    #                     users: ActiveModel::SerializableResource.new(
    #                                 users, 
    #                                 each_serializer: UserSerializer
    #                             )
    #                 }
    # end

    # def searchAlmUser
    #     users = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'AlmUser').map{|searchObject| 
    #         User.find(searchObject.searchable_id)
    #     }.flatten.uniq

    #     users = Kaminari.paginate_array(users).page(params[:page]).per(numberOfPage)
    #     if users.total_count == 0 || (users.total_count - (params[:page].to_i * numberOfPage)) < 0
    #         itemsremaining = 0
    #     elsif users.total_count < numberOfPage
    #         itemsremaining = users.total 
    #     else
    #         itemsremaining = users.total_count - (params[:page].to_i * numberOfPage)
    #     end

    #     render json: {  itemsremaining:  itemsremaining,
    #                     users: ActiveModel::SerializableResource.new(
    #                                 users, 
    #                                 each_serializer: UserSerializer
    #                             )
    #                 }
    # end

    def searchUsers
        users = PgSearch.multisearch(params[:keywords]).where(searchable_type: ['AlmUser', 'User']).map{|searchObject| 
            if searchObject.searchable_type == 'User'
                User.find(searchObject.searchable_id)
            else
                AlmUser.find(searchObject.searchable_id)
            end
        }.flatten.uniq

        users = Kaminari.paginate_array(users).page(params[:page]).per(numberOfPage)
        if users.total_count == 0 || (users.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif users.total_count < numberOfPage
            itemsremaining = users.total_count 
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
        if params[:account_type] == '1'
            userEmail = User.find(params[:id]).email
        else
            userEmail = AlmUser.find(params[:id]).email
        end
        subject = params[:subject]

        ContactUserMailer.with(message: message, email: userEmail, subject: subject).contact_user.deliver_later

        render json: {status: "Email Sent"}
    end

    def showPost
        post = Post.find(params[:id])

        render json: PostSerializer.new( post ).attributes
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
        if !user.has_role? :admin 
            return render json: {status: "Must be an admin to continue", user: user}, status: 401
        end
    end
end
