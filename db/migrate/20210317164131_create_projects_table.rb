class CreateProjectsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :description
      t.bigint :user_id, null: false
      t.decimal :hours_per_month, precision: 10
      t.decimal :restricted_start_hour, precision: 10
      t.decimal :restricted_end_hour, precision: 10

      t.timestamps
    end

    add_foreign_key :projects, :users, column: :user_id, primary_key: :id
  end
end
