class CreateCourseHoursTable < ActiveRecord::Migration[6.0]
  def change
    create_table :course_hours do |t|
      t.string :type, null: false
      t.bigint :course_id, null: false

      t.timestamps
    end

    add_foreign_key :course_hours, :courses, column: :course_id, primary_key: :id
  end
end
