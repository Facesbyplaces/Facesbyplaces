class AddReportableToReports < ActiveRecord::Migration[6.0]
  def change
    add_reference :reports, :reportable, polymorphic: true, null: false
  end
end
