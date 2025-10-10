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

ActiveRecord::Schema[7.1].define(version: 2025_09_07_221000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.bigint "work_experience_id", null: false
    t.text "content", null: false
    t.integer "display_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_experience_id"], name: "index_achievements_on_work_experience_id"
  end

  create_table "career_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_career_profiles_on_user_id"
  end

  create_table "experience_summaries", force: :cascade do |t|
    t.bigint "work_experience_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_experience_id"], name: "index_experience_summaries_on_work_experience_id"
  end

  create_table "improvements", force: :cascade do |t|
    t.bigint "work_experience_id", null: false
    t.text "content", null: false
    t.integer "display_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_experience_id"], name: "index_improvements_on_work_experience_id"
  end

  create_table "resumes", force: :cascade do |t|
    t.string "company", null: false
    t.string "position", null: false
    t.text "tasks", null: false
    t.text "improvements", null: false
    t.text "achievements", null: false
    t.text "summary", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.date "start_at", null: false
    t.date "end_at"
    t.index ["start_at"], name: "index_resumes_on_start_at"
    t.index ["user_id"], name: "index_resumes_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "work_experience_id", null: false
    t.text "content", null: false
    t.integer "display_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_experience_id"], name: "index_tasks_on_work_experience_id"
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

  create_table "work_experiences", force: :cascade do |t|
    t.bigint "career_profile_id", null: false
    t.string "company", null: false
    t.string "position", null: false
    t.date "start_at", null: false
    t.date "end_at"
    t.boolean "is_current", default: false
    t.integer "display_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["career_profile_id"], name: "index_work_experiences_on_career_profile_id"
  end

  add_foreign_key "achievements", "work_experiences"
  add_foreign_key "career_profiles", "users"
  add_foreign_key "experience_summaries", "work_experiences"
  add_foreign_key "improvements", "work_experiences"
  add_foreign_key "resumes", "users"
  add_foreign_key "tasks", "work_experiences"
  add_foreign_key "work_experiences", "career_profiles"
end
