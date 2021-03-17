class CreateOtherActivitiesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :other_activities do |t|
      t.string :name, null: false
      t.string :description

      t.timestamps
    end
  end
end
