module Reportable
    include ApplicationConcern
  
    def set_searched_reports
        reportsId = PgSearch.multisearch(params[:keywords]).where(searchable_type: 'Report').pluck('searchable_id')
        searchedReports = Report.where(id: reportsId)
        @reports = searchedReports.page(params[:page]).per(numberOfPage)
    end

    def set_reports
        reports = Report.all.order("reports.id DESC")
        @reports = reports.page(params[:page]).per(numberOfPage)
    end

    def set_report
        @report = Report.find(params[:id])
    end

    def set_reported
        case @report.reportable_type
        when "Memorial"
            reportable = Memorial.find(@report.reportable_id)
            @reported = reportable.name
        when "AlmUser"
            reportable = AlmUser.find(@report.reportable_id)
            @reported = reportable.first_name + " " + reportable.last_name
        when "Blm"
            reportable = Blm.find(@report.reportable_id)
            @reported = reportable.name
        when "User"
            reportable = User.find(@report.reportable_id)
            @reported = reportable.first_name + " " + reportable.last_name
        when "Post"
            reportable = Post.find(@report.reportable_id)
            @reported = reportable.body
        end
    end
end