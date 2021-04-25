# frozen_string_literal: true

class CreateEventsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.timestamp :start_date, null: false
      t.timestamp :end_date, null: false
      t.bigint :activity_id
      t.string :activity_type
      t.string :description, null: false
      t.bigint :user_id, null: false
      t.string :type

      t.timestamps
    end

    add_index :events, %i[activity_id activity_type], name: 'activity_index'
    add_foreign_key :events, :users, column: :user_id, primary_key: :id
  end
end
