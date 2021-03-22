class ProjectHour < ApplicationRecord
  @inheritance_column = :not_type

  belongs_to :project, foreign_key: :project_id, primary_key: :id, inverse_of: :project_hours
  has_many :timelines, as: :activity
end
