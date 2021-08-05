class Api::V1::Admin::ReportsController < ApplicationController
    include Reportable
    before_action :admin_only
    before_action :set_searched_reports, only: [:searchReport]
    before_action :set_reports, only: [:allReports]
    before_action :set_report, only: [:showReport, :editReport, :deleteReport]
    before_action :set_reported, only: [:showReport]

    # Searh Report
    def searchReport
        render json: {  itemsremaining:  itemsRemaining(@reports),
                        reports: @reports
                    }
    end
    
    def allReports
        render json: {  itemsremaining:  itemsRemaining(@reports),
                        reports: @reports
                    }
    end
    
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
                    alm_memorials = Memorial.all
                    render json: { memorials: alm_memorials }
            when "AlmUser"
                    users = AlmUser.all
                    render json: { alm_users: users }
            when "Blm"
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

    def showReport  
        render json: { report: @report, reported: @reported }, status: 200
    end

    def editReport
        return render json: {error: "Params is empty"} unless params_presence(report_params)
        @report.update(report_params)
        render json: {success: "Report updated", report: @report}, status: 200
    end
    
    def deleteReport
        return render json: {status: "Report not found"} unless @report
        @report.destroy 
        render json: {status: :deleted}
    end

    private

    def report_params
        params.require(:report).permit(:subject, :description, :reportable_type, :reportable_id)
    end

    def itemsRemaining(reports)
        if reports.total_count == 0 || (reports.total_count - (params[:page].to_i * numberOfPage)) < 0
            itemsremaining = 0
        elsif reports.total_count < numberOfPage
            itemsremaining = reports.total_count 
        else
            itemsremaining = reports.total_count - (params[:page].to_i * numberOfPage)
        end
    end 

    def admin_only
        unless user().has_role? :admin  
            return render json: {status: "Must be an admin to continue"}, status: 401
        end
    end
end