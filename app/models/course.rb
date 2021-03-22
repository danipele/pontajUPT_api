class Course < ApplicationRecord
  has_many :course_hour, foreign_key: :course_id, primary_key: :id, inverse_of: :course, dependent: :destroy
  belongs_to :user, foreign_key: :user_id, primary_key: :id, inverse_of: :courses
end
