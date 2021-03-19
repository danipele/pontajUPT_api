class AddSemesterToCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :semester, :string, null: false
  end
end
