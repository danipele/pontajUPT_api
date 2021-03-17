class Course < ApplicationRecord
  has_many :course_hour, foreign_key: course_id, primary_key: id, inverse_of: :course, dependent: :destroy
end
