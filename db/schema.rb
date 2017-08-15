# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170815053831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "btree_gin"
  enable_extension "btree_gist"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "image", default: "", null: false
    t.uuid "super_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["super_category_id"], name: "index_categories_on_super_category_id"
  end

  create_table "designer_finance_infos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "bank_name", default: "", null: false
    t.string "bank_branch", default: "", null: false
    t.string "ifsc_code", default: "", null: false
    t.string "account_number", default: "", null: false
    t.string "blank_cheque_proof", default: "", null: false
    t.string "personal_pan_number", default: "", null: false
    t.string "personal_pan_number_proof", default: "", null: false
    t.string "business_pan_number", default: "", null: false
    t.string "business_pan_number_proof", default: "", null: false
    t.string "tin_number", default: "", null: false
    t.string "tin_number_proof", default: "", null: false
    t.string "gstin_number", default: "", null: false
    t.string "gstin_number_proof", default: "", null: false
    t.string "business_address_proof", default: "", null: false
    t.uuid "designer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_number"], name: "index_designer_finance_infos_on_account_number", unique: true
    t.index ["business_pan_number"], name: "index_designer_finance_infos_on_business_pan_number", unique: true
    t.index ["designer_id"], name: "index_designer_finance_infos_on_designer_id"
    t.index ["gstin_number"], name: "index_designer_finance_infos_on_gstin_number", unique: true
    t.index ["personal_pan_number"], name: "index_designer_finance_infos_on_personal_pan_number", unique: true
    t.index ["tin_number"], name: "index_designer_finance_infos_on_tin_number", unique: true
  end

  create_table "designer_store_infos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "display_name", default: "", null: false
    t.string "registered_name", default: "", null: false
    t.string "pincode", default: "", null: false
    t.string "country", default: "", null: false
    t.string "state", default: "", null: false
    t.string "city", default: "", null: false
    t.text "address_line_1", default: "", null: false
    t.text "address_line_2"
    t.string "contact_number", default: "", null: false
    t.decimal "min_order_price", precision: 9, scale: 2, default: "0.0", null: false
    t.integer "processing_time", default: 0, null: false
    t.uuid "designer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["designer_id"], name: "index_designer_store_infos_on_designer_id"
    t.index ["display_name"], name: "index_designer_store_infos_on_display_name", unique: true
    t.index ["min_order_price"], name: "index_designer_store_infos_on_min_order_price", using: :gin
    t.index ["processing_time"], name: "index_designer_store_infos_on_processing_time", using: :gin
    t.index ["registered_name"], name: "index_designer_store_infos_on_registered_name", unique: true
  end

  create_table "designers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "full_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.string "mobile_number", default: "", null: false
    t.string "location", default: "", null: false
    t.string "avatar"
    t.boolean "available", default: true, null: false
    t.string "pin"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.string "reset_password_token"
    t.datetime "reset_password_token_sent_at"
    t.datetime "reset_password_at"
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_designers_on_confirmation_token", unique: true
    t.index ["email"], name: "index_designers_on_email", unique: true
    t.index ["mobile_number"], name: "index_designers_on_mobile_number", unique: true
    t.index ["reset_password_token"], name: "index_designers_on_reset_password_token", unique: true
  end

  create_table "sub_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "image", default: "", null: false
    t.uuid "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
    t.index ["name"], name: "index_sub_categories_on_name", unique: true
  end

  create_table "super_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "image", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_super_categories_on_name", unique: true
  end

  create_table "user_identities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "uid", default: "", null: false
    t.string "provider", default: "", null: false
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid", "provider"], name: "index_user_identities_on_uid_and_provider", unique: true
    t.index ["user_id"], name: "index_user_identities_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "full_name", default: "", null: false
    t.string "username", default: "", null: false
    t.string "mobile_number", default: "", null: false
    t.string "gender", null: false
    t.string "avatar"
    t.string "email", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.datetime "confirmed_at"
    t.string "reset_password_token"
    t.datetime "reset_password_token_sent_at"
    t.datetime "reset_password_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["mobile_number"], name: "index_users_on_mobile_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
    t.index ["verified"], name: "index_users_on_verified", where: "verified"
  end

  add_foreign_key "categories", "super_categories"
  add_foreign_key "designer_finance_infos", "designers"
  add_foreign_key "designer_store_infos", "designers"
  add_foreign_key "sub_categories", "categories"
  add_foreign_key "user_identities", "users"
end
