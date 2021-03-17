class CreateCoursesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.decimal :student_year, null: false
      t.string :faculty, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
