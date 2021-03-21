class AddSemesterToCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :semester, :decimal, precision: 10, null: false
  end
end
