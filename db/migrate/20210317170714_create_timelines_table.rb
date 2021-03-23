class CreateTimelinesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :timelines do |t|
      t.timestamp :start_date, null: false
      t.timestamp :end_date, null: false
      t.bigint :activity_id, null: false
      t.string :activity_type, null: false
      t.string :description, null: false
      t.bigint :user_id, null: false
      t.boolean :all_day, default: false

      t.timestamps
    end

    add_index :timelines, %i[activity_id activity_type], name: 'activity_index'
    add_foreign_key :timelines, :users, column: :user_id, primary_key: :id
  end
end
