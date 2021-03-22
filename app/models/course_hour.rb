class CourseHour < ApplicationRecord
  @inheritance_column = :not_type

  belongs_to :course, foreign_key: :course_id, primary_key: :id, inverse_of: :course_hours
  has_many :timelines, as: :activity
end
