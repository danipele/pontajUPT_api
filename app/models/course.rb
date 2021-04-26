# frozen_string_literal: true

class Course < ApplicationRecord
  include Constants

  has_many :course_hours, foreign_key: :course_id, primary_key: :id, inverse_of: :course, dependent: :nullify
  belongs_to :user, foreign_key: :user_id, primary_key: :id, inverse_of: :courses

  def add_course_hours
    course_hours.create type: COURSE
    course_hours.create type: SEMINAR
    course_hours.create type: LABORATORY
    course_hours.create type: PROJECT_HOUR
    course_hours.create type: EVALUATION
    course_hours.create type: CONSULTATIONS
    course_hours.create type: TEACHING_ACTIVITY_PREPARATION
  end
end
