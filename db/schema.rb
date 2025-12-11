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

ActiveRecord::Schema[8.1].define(version: 2025_12_11_193000) do
  create_table "appointments", force: :cascade do |t|
    t.integer "client_id", null: false
    t.datetime "created_at", null: false
    t.integer "dog_id"
    t.datetime "ends_at", null: false
    t.text "notes"
    t.string "recurrence_rule"
    t.string "series_id"
    t.integer "service_type_id", null: false
    t.datetime "starts_at", null: false
    t.integer "status", default: 0, null: false
    t.text "trainer_notes"
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_appointments_on_client_id"
    t.index ["dog_id"], name: "index_appointments_on_dog_id"
    t.index ["series_id"], name: "index_appointments_on_series_id"
    t.index ["service_type_id"], name: "index_appointments_on_service_type_id"
    t.index ["starts_at"], name: "index_appointments_on_starts_at"
    t.index ["status"], name: "index_appointments_on_status"
  end

  create_table "clients", force: :cascade do |t|
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.datetime "discarded_at"
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.text "notes"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_clients_on_deleted_at"
    t.index ["discarded_at"], name: "index_clients_on_discarded_at"
    t.index ["email"], name: "index_clients_on_email", unique: true
  end

  create_table "dogs", force: :cascade do |t|
    t.string "breed"
    t.integer "client_id", null: false
    t.datetime "created_at", null: false
    t.date "date_of_birth"
    t.datetime "deleted_at"
    t.datetime "discarded_at"
    t.text "medical_notes"
    t.string "name", null: false
    t.string "sex"
    t.text "temperament"
    t.text "training_goals"
    t.text "training_history"
    t.datetime "updated_at", null: false
    t.decimal "weight", precision: 5, scale: 2
    t.index ["client_id"], name: "index_dogs_on_client_id"
    t.index ["deleted_at"], name: "index_dogs_on_deleted_at"
    t.index ["discarded_at"], name: "index_dogs_on_discarded_at"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "appointment_id", null: false
    t.datetime "created_at", null: false
    t.integer "dog_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "waitlist_position"
    t.index ["appointment_id", "dog_id"], name: "index_enrollments_on_appointment_id_and_dog_id", unique: true
    t.index ["appointment_id"], name: "index_enrollments_on_appointment_id"
    t.index ["dog_id"], name: "index_enrollments_on_dog_id"
    t.index ["status"], name: "index_enrollments_on_status"
  end

  create_table "invoice_line_items", force: :cascade do |t|
    t.integer "appointment_id"
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.integer "invoice_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "total", precision: 10, scale: 2, null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_invoice_line_items_on_appointment_id"
    t.index ["invoice_id"], name: "index_invoice_line_items_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "client_id", null: false
    t.datetime "created_at", null: false
    t.date "due_date", null: false
    t.string "invoice_number", null: false
    t.date "issue_date", null: false
    t.text "notes"
    t.datetime "paid_at"
    t.datetime "sent_at"
    t.integer "status", default: 0, null: false
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0"
    t.decimal "tax", precision: 10, scale: 2, default: "0.0"
    t.decimal "total", precision: 10, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["due_date"], name: "index_invoices_on_due_date"
    t.index ["invoice_number"], name: "index_invoices_on_invoice_number", unique: true
    t.index ["status"], name: "index_invoices_on_status"
  end

  create_table "marketing_content_media", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "marketing_content_id", null: false
    t.integer "session_media_id", null: false
    t.datetime "updated_at", null: false
    t.index ["marketing_content_id", "session_media_id"], name: "idx_marketing_content_media_unique", unique: true
    t.index ["marketing_content_id"], name: "index_marketing_content_media_on_marketing_content_id"
    t.index ["session_media_id"], name: "index_marketing_content_media_on_session_media_id"
  end

  create_table "marketing_contents", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "platform"
    t.datetime "published_at"
    t.datetime "scheduled_at"
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["platform"], name: "index_marketing_contents_on_platform"
    t.index ["scheduled_at"], name: "index_marketing_contents_on_scheduled_at"
    t.index ["status"], name: "index_marketing_contents_on_status"
  end

  create_table "media_consents", force: :cascade do |t|
    t.integer "client_id", null: false
    t.datetime "consented_at"
    t.datetime "created_at", null: false
    t.boolean "internal_only", default: true, null: false
    t.boolean "marketing_allowed", default: false, null: false
    t.text "notes"
    t.boolean "social_media_allowed", default: false, null: false
    t.datetime "updated_at", null: false
    t.boolean "website_allowed", default: false, null: false
    t.index ["client_id"], name: "index_media_consents_on_client_id", unique: true
  end

  create_table "report_cards", force: :cascade do |t|
    t.integer "appointment_id"
    t.text "areas_for_improvement"
    t.datetime "created_at", null: false
    t.integer "dog_id", null: false
    t.integer "focus_score"
    t.text "homework"
    t.integer "leash_manners_score"
    t.integer "obedience_score"
    t.integer "overall_score"
    t.date "report_date", null: false
    t.string "share_token"
    t.datetime "share_token_expires_at"
    t.integer "socialization_score"
    t.integer "status", default: 0, null: false
    t.text "strengths"
    t.text "trainer_notes"
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_report_cards_on_appointment_id"
    t.index ["dog_id"], name: "index_report_cards_on_dog_id"
    t.index ["report_date"], name: "index_report_cards_on_report_date"
    t.index ["share_token"], name: "index_report_cards_on_share_token", unique: true
  end

  create_table "service_types", force: :cascade do |t|
    t.boolean "active", default: true
    t.integer "capacity", default: 1
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "duration_minutes", default: 60, null: false
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_service_types_on_active"
    t.index ["name"], name: "index_service_types_on_name", unique: true
  end

  create_table "session_media", force: :cascade do |t|
    t.integer "appointment_id", null: false
    t.text "caption"
    t.datetime "created_at", null: false
    t.integer "dog_id"
    t.boolean "featured", default: false
    t.string "media_type", null: false
    t.datetime "taken_at"
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_session_media_on_appointment_id"
    t.index ["dog_id"], name: "index_session_media_on_dog_id"
    t.index ["featured"], name: "index_session_media_on_featured"
    t.index ["media_type"], name: "index_session_media_on_media_type"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "appointments", "clients"
  add_foreign_key "appointments", "dogs"
  add_foreign_key "appointments", "service_types"
  add_foreign_key "dogs", "clients"
  add_foreign_key "enrollments", "appointments"
  add_foreign_key "enrollments", "dogs"
  add_foreign_key "invoice_line_items", "appointments"
  add_foreign_key "invoice_line_items", "invoices"
  add_foreign_key "invoices", "clients"
  add_foreign_key "marketing_content_media", "marketing_contents"
  add_foreign_key "marketing_content_media", "session_media", column: "session_media_id"
  add_foreign_key "media_consents", "clients"
  add_foreign_key "report_cards", "appointments"
  add_foreign_key "report_cards", "dogs"
  add_foreign_key "session_media", "appointments"
  add_foreign_key "session_media", "dogs"
  add_foreign_key "sessions", "users"
end
