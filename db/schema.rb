# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_17_170714) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'course_hours', force: :cascade do |t|
    t.string 'type', null: false
    t.bigint 'course_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'courses', force: :cascade do |t|
    t.string 'name', null: false
    t.decimal 'student_year', null: false
    t.string 'faculty', null: false
    t.string 'description'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'holidays', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'other_activities', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'description'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'project_hours', force: :cascade do |t|
    t.string 'type', null: false
    t.bigint 'project_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'projects', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'description'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'timelines', force: :cascade do |t|
    t.datetime 'start_date', null: false
    t.datetime 'end_date', null: false
    t.bigint 'activity_id', null: false
    t.string 'activity_type', null: false
    t.string 'description', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[activity_id activity_type], name: 'activity_index'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', null: false
    t.string 'encrypted_password', null: false
    t.string 'first_name', null: false
    t.string 'last_name', null: false
    t.string 'type', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  add_foreign_key 'course_hours', 'courses'
  add_foreign_key 'project_hours', 'projects'
end
