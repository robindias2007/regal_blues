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

ActiveRecord::Schema.define(version: 20170814192236) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "btree_gin"
  enable_extension "btree_gist"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"

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

  add_foreign_key "user_identities", "users"
end
