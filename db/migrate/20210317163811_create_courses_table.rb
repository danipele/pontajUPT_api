class CreateCoursesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.decimal :student_year, null: false, precision: 10
      t.decimal :semester, null: false, precision: 10
      t.string :cycle, null: false
      t.string :faculty, null: false
      t.string :description
      t.bigint :user_id, null: false

      t.timestamps null: false
    end

    add_foreign_key :courses, :users, column: :user_id, primary_key: :id
  end
end
