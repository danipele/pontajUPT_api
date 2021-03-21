class AddCycleToCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :cycle, :string, null: false
  end
end
