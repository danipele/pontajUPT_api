class AddPrecisionToStudentYearColumn < ActiveRecord::Migration[6.0]
  def change
    change_column :courses, :student_year, :decimal, precision: 10, null: false
  end
end
