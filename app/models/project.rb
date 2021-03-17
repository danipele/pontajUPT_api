class Project < ApplicationRecord
  has_many :project_hours, foreign_key: :project_id, primary_key: :id, inverse_of: :project, dependent: :destroy
end
