class Report < ApplicationRecord
    belongs_to :reportable, polymorphic: true


    # Search
    include PgSearch::Model
    multisearchable against: [:reportable_type, :subject, :description]
end
