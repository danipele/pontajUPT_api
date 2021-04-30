# frozen_string_literal: true

class CourseHour < ApplicationRecord
  include Constants

  @inheritance_column = :not_type

  belongs_to :course, foreign_key: :course_id, primary_key: :id, inverse_of: :course_hours
  has_many :events, as: :activity

  def name_id
    COURSE_HOUR
  end
end
