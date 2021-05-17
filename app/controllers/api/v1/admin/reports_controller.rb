class Api::V1::Admin::ReportsController < ApplicationController
    before_action :check_user
    before_action :admin_only

    # Report
    # Index Report
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
    # Create Report
    def createReport
        @report = Report.new(report_params)
        @report.save!

        render json: {
            success: true,
            report_id:          @report.id,
            reportable_type:    @report.reportable_type,
            reportable_id:      @report.reportable_id,
            subject:            @report.subject,
            description:        @report.description }, status: 200
    end

    def fetchData
        case params[:reportable_type]
            when "Memorial"
                    #ALM Memorials
                    alm_memorials = Memorial.all

                    render json: { memorials: alm_memorials }
            when "AlmUser"
                    users = AlmUser.all
                    render json: { alm_users: users }
            when "Blm"
                    #ALM Memorials
                    blm_memorials = Blm.all

                    render json: { blms: blm_memorials }
            when "User"
                    users = User.all.where.not(guest: true, username: "admin")
                    render json: { blm_users: users }
            when "Post"
                    posts = Post.all
                    render json: { posts: posts }
        end
    end 

    # Show Report
    def showReport
        report = Report.find(params[:id])
        case report.reportable_type
            when "Memorial"
                reportable = Memorial.find(report.reportable_id)
                reported = reportable.name
            when "AlmUser"
                reportable = AlmUser.find(report.reportable_id)
                reported = reportable.first_name + " " + reportable.last_name
            when "Blm"
                reportable = Blm.find(report.reportable_id)
                reported = reportable.name
            when "User"
                reportable = User.find(report.reportable_id)
                reported = reportable.first_name + " " + reportable.last_name
            when "Post"
                reportable = Post.find(report.reportable_id)
                reported = reportable.body
        end
        render json: { report: report, reported: reported }, status: 200
    end
    # Edit Report
    def editReport
        report = Report.find(params[:id])

         # check if data sent is empty or not
         check = params_presence(params)
         if check == true
             # Update memorial details
             report.update(report_params)
 
             return render json: {success: "Report updated", report: report}, status: 200
         else
             return render json: {error: "#{check} is empty"}
         end
    end
    # Delete Report
    def deleteReport
        report = Report.find(params[:id])

        if report
            report.destroy 
            render json: {status: :deleted}
        else
            render json: {status: "Report not found"}
        end
    end
    # Searh Report
    def searchReport
        reportsId = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Report').pluck('searchable_id')
        puts reportsId
        reports = Report.where(id: reportsId)
        
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
                        # reports: ActiveModel::SerializableResource.new(
                        #     reports, 
                        #     each_serializer: PostSerializer
                        # )
                    }
    end

    def transactions
        transactions = Transaction.where(page_type: params[:page_type], page_id: params[:page_id])

        render json: transactions
    end

    def show_transaction
        transaction = Transaction.find(params[:transaction_id])

        render json: transaction
    end

    def PushNotification(device_tokens, title, message)
        require 'fcm'
        puts        "\n-- Device Token : --\n#{device_tokens}"
        logger.info "\n-- Device Token : --\n#{device_tokens}"

        fcm_client = FCM.new(Rails.application.credentials.dig(:firebase, :server_key))
        options = { notification: { 
                        body: 'message',
                        title: 'title',
                    }
                }
        begin
            response = fcm_client.send(device_tokens, options)
        rescue StandardError => err
            puts        "\n-- PushNotification : Error --\n#{err}"
            logger.info "\n-- PushNotification : Error --\n#{err}"
        end
  
        puts response
    end


    private

    def report_params
        params.require(:report).permit(:subject, :description, :reportable_type, :reportable_id)
    end

    def admin_only
        if !user.has_role? :admin 
            return render json: {status: "Must be an admin to continue"}, status: 401
        end
    end
end