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

ActiveRecord::Schema.define(version: 2020_12_16_163610) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_names"
    t.string "surname"
    t.string "address"
    t.string "postcode"
    t.string "telephone"
    t.string "mobile"
    t.jsonb "gds_import_data"
    t.boolean "is_vulnerable"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "email"
    t.string "additional_info"
    t.integer "count_people_in_house"
    t.boolean "any_children_under_age"
    t.text "delivery_details"
    t.boolean "any_dietary_requirements"
    t.text "dietary_details"
    t.text "cooking_facilities"
    t.boolean "eligible_for_free_prescriptions"
    t.string "nhs_number"
    t.date "date_of_birth"
    t.boolean "has_covid_symptoms"
    t.integer "lock_version", default: 0
    t.string "channel"
    t.boolean "no_calls_flag", default: false
    t.boolean "deceased_flag", default: false
    t.boolean "share_data_flag"
    t.bigint "lead_service_id"
    t.string "lead_service_note"
    t.bigint "imported_item_id"
    t.string "test_and_trace_account_id"
    t.date "test_trace_creation_date"
    t.date "isolation_start_date"
  end

  create_table "imported_items", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "imported"
    t.integer "failed"
    t.bigint "uploaded_by_user_id"
    t.index ["name"], name: "index_imported_items_on_name", unique: true
  end

  create_table "needs", force: :cascade do |t|
    t.bigint "contact_id", null: false
    t.bigint "user_id"
    t.string "name", null: false
    t.datetime "completed_on"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "category"
    t.boolean "is_urgent", default: false
    t.datetime "start_on"
    t.jsonb "supplemental_data"
    t.integer "lock_version", default: 0
    t.bigint "role_id"
    t.string "status", default: "to_do"
    t.datetime "deleted_at"
    t.bigint "assessment_id"
    t.boolean "send_email", default: false
    t.index ["contact_id"], name: "index_needs_on_contact_id"
    t.index ["deleted_at"], name: "index_needs_on_deleted_at"
    t.index ["role_id"], name: "index_needs_on_role_id"
    t.index ["status"], name: "index_needs_on_status"
    t.index ["user_id"], name: "index_needs_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "body", null: false
    t.bigint "need_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.string "category"
    t.jsonb "import_data"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_notes_on_deleted_at"
    t.index ["need_id"], name: "index_notes_on_need_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "passwordless_sessions", force: :cascade do |t|
    t.string "authenticatable_type"
    t.bigint "authenticatable_id"
    t.datetime "timeout_at", null: false
    t.datetime "expires_at", null: false
    t.datetime "claimed_at"
    t.text "user_agent", null: false
    t.string "remote_addr", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authenticatable_type", "authenticatable_id"], name: "authenticatable"
  end

  create_table "rejected_contacts", force: :cascade do |t|
    t.bigint "imported_item_id", null: false
    t.string "test_and_trace_account_id"
    t.string "nhs_number"
    t.boolean "is_vulnerable"
    t.string "first_name"
    t.string "middle_names"
    t.string "surname"
    t.date "date_of_birth"
    t.text "email"
    t.string "mobile"
    t.string "telephone"
    t.string "address"
    t.string "postcode"
    t.string "needs"
    t.date "test_trace_creation_date"
    t.date "isolation_start_date"
    t.string "reason"
    t.index ["imported_item_id"], name: "index_rejected_contacts_on_imported_item_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.string "role", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
    t.index ["role"], name: "index_roles_on_role", unique: true
  end

  create_table "user_roles", id: false, force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "user_id", null: false
    t.index ["role_id", "user_id"], name: "index_user_roles_on_role_id_and_user_id", unique: true
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "email", null: false
    t.datetime "invited", null: false
    t.datetime "last_logged_in"
    t.bigint "role_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "contacts", "imported_items"
  add_foreign_key "contacts", "roles", column: "lead_service_id"
  add_foreign_key "needs", "contacts"
  add_foreign_key "needs", "needs", column: "assessment_id"
  add_foreign_key "needs", "roles"
  add_foreign_key "needs", "users"
  add_foreign_key "notes", "needs"
  add_foreign_key "notes", "users"
  add_foreign_key "rejected_contacts", "imported_items"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "roles"
end
