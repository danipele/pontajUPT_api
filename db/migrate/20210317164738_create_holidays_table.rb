class CreateHolidaysTable < ActiveRecord::Migration[6.0]
  def change
    create_table :holidays do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
