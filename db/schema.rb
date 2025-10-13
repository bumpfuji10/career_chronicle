# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_10_13_014652) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_achievements_on_task_id"
  end

  create_table "companies", force: :cascade do |t|
    t.bigint "resume_id", null: false
    t.string "name", null: false
    t.string "industry", null: false
    t.date "started_at", null: false
    t.date "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resume_id"], name: "index_companies_on_resume_id"
    t.index ["started_at"], name: "index_companies_on_started_at"
  end

  create_table "positions", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "title", null: false
    t.date "started_at", null: false
    t.date "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "department", null: false
    t.index ["company_id"], name: "index_positions_on_company_id"
    t.index ["started_at"], name: "index_positions_on_started_at"
  end

  create_table "resumes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_resumes_on_user_id", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "position_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "task_description", null: false
    t.text "improvement"
    t.index ["position_id"], name: "index_tasks_on_position_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "session_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name"
    t.index ["session_token"], name: "index_users_on_session_token", unique: true
  end

  add_foreign_key "achievements", "tasks"
  add_foreign_key "companies", "resumes"
  add_foreign_key "positions", "companies"
  add_foreign_key "resumes", "users"
  add_foreign_key "tasks", "positions"
end
