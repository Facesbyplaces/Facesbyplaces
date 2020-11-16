class Api::V1::Reports::ReportController < ApplicationController
    before_action :authenticate_user!

    def create
        @report = Report.new(report_params)
        @report.save!

        render json: {
            success: true,
            report_id:          @report.id,
            reportable_type:    @report.reportable_type,
            reportable_id:      @report.reportable_id,
            subject:            @report.subject,
            description:        @report.description,
            status: 200}, status: 200
    end

    private
    def report_params
        params.require(:report).permit(:reportable_type, :reportable_id, :subject, :description)
    end

end