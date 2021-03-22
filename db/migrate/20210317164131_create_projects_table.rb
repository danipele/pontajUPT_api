class CreateProjectsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :description
      t.bigint :user_id, null: false

      t.timestamps
    end

    add_foreign_key :projects, :users, column: :user_id, primary_key: :id
  end
end
