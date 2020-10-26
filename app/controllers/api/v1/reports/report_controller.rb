class Api::V1::Reports::ReportController < ApplicationController

    def create
        @report = Report.new(report_params)
        @report.save!

        render json: {
            success: true,
            report_id: @report.id, 
            user_id: @report.user_id, 
            memorial_id: @report.memorial_id, 
            post_id: @report.post_id,
            subject: @report.subject,
            description: @report.description,
            status: 200}, status: 200
    end

    private
    def report_params
        params.permit(:user_id, :memorial_id, :post_id, :subject, :description)
    end

end