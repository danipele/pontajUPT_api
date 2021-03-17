class CreateProjectHoursTable < ActiveRecord::Migration[6.0]
  def change
    create_table :project_hours do |t|
      t.string :type, null: false
      t.bigint :project_id, null: false

      t.timestamps
    end

    add_foreign_key :project_hours, :projects, column: :project_id, primary_key: :id
  end
end
