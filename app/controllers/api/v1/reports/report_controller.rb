class Api::V1::Reports::ReportController < ApplicationController

    def create
        @report = Report.new(report_params)
        @report.save!

        render json: {
            success: true,
            report_id:      @report.id,
            page_type:      @report.page_type,
            page_id:        @report.page_id,
            user_id:        @report.user_id,  
            post:           @report.post,
            subject:        @report.subject,
            description:    @report.description,
            status: 200}, status: 200
    end

    private
    def report_params
        params.require(:report).permit(:page_id, :page_type, :user_id, :post_id, :subject, :description)
    end

end