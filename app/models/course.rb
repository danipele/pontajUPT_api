class Course < ApplicationRecord
  has_many :course_hours, foreign_key: :course_id, primary_key: :id, inverse_of: :course, dependent: :nullify
  belongs_to :user, foreign_key: :user_id, primary_key: :id, inverse_of: :courses

  def add_course_hours
    course_hours.create type: 'Curs'
    course_hours.create type: 'Seminar'
    course_hours.create type: 'Laborator'
    course_hours.create type: 'Proiect'
    course_hours.create type: 'Evaluare'
    course_hours.create type: 'Consultatii'
    course_hours.create type: 'Pregatire pentru activitatea didactica'
  end
end
