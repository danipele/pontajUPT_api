class CreateTimelinesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :timelines do |t|
      t.timestamp :start_date, null: false
      t.timestamp :end_date, null: false
      t.bigint :activity_id, null: false
      t.string :activity_type, null: false
      t.string :description, null: false

      t.timestamps
    end

    add_index :timelines, %i[activity_id activity_type], name: 'activity_index'
  end
end
