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

ActiveRecord::Schema.define(version: 2020_03_28_054759) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contact_list_users", force: :cascade do |t|
    t.bigint "contact_list_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contact_list_id"], name: "index_contact_list_users_on_contact_list_id"
    t.index ["user_id"], name: "index_contact_list_users_on_user_id"
  end

  create_table "contact_lists", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_names"
    t.string "surname"
    t.string "address"
    t.string "postcode"
    t.string "telephone"
    t.string "mobile"
    t.jsonb "nhs_import_data"
    t.boolean "is_vulnerable"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "contact_list_id"
    t.index ["contact_list_id"], name: "index_contacts_on_contact_list_id"
  end

  create_table "organisations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_organisations_on_name"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.datetime "due_by"
    t.datetime "completed_on"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contact_id"], name: "index_tasks_on_contact_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.bigint "organisation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organisation_id"], name: "index_users_on_organisation_id"
  end

  add_foreign_key "contact_list_users", "contact_lists"
  add_foreign_key "contact_list_users", "users"
  add_foreign_key "contacts", "contact_lists"
  add_foreign_key "tasks", "contacts"
  add_foreign_key "tasks", "users"
  add_foreign_key "users", "organisations"
end
