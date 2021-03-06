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

ActiveRecord::Schema.define(version: 20180322091549) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "btree_gin"
  enable_extension "pg_trgm"

  create_table "addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "country", default: "", null: false
    t.string "pincode", default: "", null: false
    t.text "street_address", default: "", null: false
    t.string "nickname", default: "", null: false
    t.string "city", default: "", null: false
    t.string "state", default: "", null: false
    t.string "landmark"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "image", default: "", null: false
    t.uuid "super_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["super_category_id"], name: "index_categories_on_super_category_id"
  end

  create_table "config_variables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "event_name"
    t.string "param1"
    t.string "param2"
    t.string "param3"
    t.string "param4"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "configurations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "event_name"
    t.datetime "time"
    t.string "param1"
    t.string "param2"
    t.string "param3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "sender_id"
    t.string "receiver_type"
    t.uuid "receiver_id"
    t.text "conversationable_id"
    t.string "conversationable_type"
    t.index ["receiver_type", "receiver_id"], name: "index_conversations_on_receiver_type_and_receiver_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "designer_categorizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "designer_id"
    t.uuid "sub_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["designer_id"], name: "index_designer_categorizations_on_designer_id"
    t.index ["sub_category_id"], name: "index_designer_categorizations_on_sub_category_id"
  end

  create_table "designer_chat_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean "active"
    t.text "bio"
    t.string "live_status"
    t.integer "skip_count", default: 0, null: false
    t.text "devise_token"
    t.boolean "gold", default: false
    t.index ["active"], name: "index_designers_on_active", where: "active"
    t.index ["confirmation_token"], name: "index_designers_on_confirmation_token", unique: true
    t.index ["email"], name: "index_designers_on_email", unique: true
    t.index ["mobile_number"], name: "index_designers_on_mobile_number", unique: true
    t.index ["reset_password_token"], name: "index_designers_on_reset_password_token", unique: true
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "resource_type"
    t.string "username"
    t.string "param1"
    t.string "param2"
    t.string "param3"
    t.string "param4"
    t.string "param5"
    t.string "param6"
    t.string "param7"
    t.string "param8"
    t.string "param9"
    t.string "param10"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "event_name"
  end

  create_table "external_searches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "query"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["query"], name: "index_external_searches_on_query", unique: true
  end

  create_table "images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "image", default: "", null: false
    t.integer "height", default: 0, null: false
    t.integer "width", default: 0, null: false
    t.string "imageable_type"
    t.uuid "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "serial_number"
    t.boolean "disabled", default: false, null: false
    t.boolean "new", default: false, null: false
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id"
  end

  create_table "measurement_tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "measurement_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "body"
    t.string "attachment"
    t.text "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read", default: false
    t.text "sender_id"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "body"
    t.text "resourceable_id"
    t.string "resourceable_type"
    t.string "notificationable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notificationable_id"
  end

  create_table "offer_measurements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "data", default: {}, null: false
    t.uuid "offer_quotation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data"], name: "index_offer_measurements_on_data", using: :gin
    t.index ["offer_quotation_id"], name: "index_offer_measurements_on_offer_quotation_id"
  end

  create_table "offer_quotation_chats", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "designer_id"
    t.uuid "offer_quotation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["designer_id"], name: "index_offer_quotation_chats_on_designer_id"
    t.index ["offer_quotation_id"], name: "index_offer_quotation_chats_on_offer_quotation_id"
    t.index ["user_id"], name: "index_offer_quotation_chats_on_user_id"
  end

  create_table "offer_quotation_galleries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.uuid "offer_quotation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offer_quotation_id"], name: "index_offer_quotation_galleries_on_offer_quotation_id"
  end

  create_table "offer_quotations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "price", precision: 12, scale: 2, default: "0.0", null: false
    t.text "description", default: "", null: false
    t.uuid "offer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "designer_note"
    t.integer "shipping_price"
    t.index ["offer_id"], name: "index_offer_quotations_on_offer_id"
  end

  create_table "offers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "designer_id"
    t.uuid "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["designer_id"], name: "index_offers_on_designer_id"
    t.index ["request_id"], name: "index_offers_on_request_id"
  end

  create_table "order_measurements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "data"
    t.uuid "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notes"
    t.string "image"
    t.index ["order_id"], name: "index_order_measurements_on_order_id"
  end

  create_table "order_options", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id"
    t.uuid "image_id"
    t.boolean "more_options", default: false, null: false
    t.boolean "designer_pick", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "offer_quotation_gallery_id"
    t.index ["image_id"], name: "index_order_options_on_image_id"
    t.index ["offer_quotation_gallery_id"], name: "index_order_options_on_offer_quotation_gallery_id"
    t.index ["order_id"], name: "index_order_options_on_order_id"
  end

  create_table "order_payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id"
    t.uuid "user_id"
    t.integer "price", default: 0, null: false
    t.string "payment_id", default: "", null: false
    t.boolean "success", default: false, null: false
    t.jsonb "extra", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_payments_on_order_id"
    t.index ["user_id"], name: "index_order_payments_on_user_id"
  end

  create_table "order_status_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id"
    t.datetime "started_at"
    t.datetime "paid_at"
    t.datetime "designer_confirmed_at"
    t.datetime "measurements_given_at"
    t.datetime "in_production_at"
    t.datetime "shipped_to_qc_at"
    t.datetime "delivered_to_qc_at"
    t.datetime "in_qc_at"
    t.datetime "shipped_to_user_at"
    t.datetime "delivered_to_user_at"
    t.datetime "rejected_by_qc_at"
    t.datetime "user_awaiting_more_options_at"
    t.datetime "designer_gave_more_options_at"
    t.datetime "user_selected_options_at"
    t.datetime "user_cancelled_at"
    t.datetime "designer_selected_fabric_unavailable_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_status_logs_on_order_id"
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "designer_id"
    t.uuid "user_id"
    t.uuid "offer_quotation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.string "order_id"
    t.index ["designer_id"], name: "index_orders_on_designer_id"
    t.index ["offer_quotation_id"], name: "index_orders_on_offer_quotation_id"
    t.index ["order_id"], name: "index_orders_on_order_id", unique: true
    t.index ["status"], name: "index_orders_on_status", using: :gin
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "picks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "cat_name"
    t.string "keywords"
    t.string "images", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_infos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "color", default: "", null: false
    t.text "fabric", default: "", null: false
    t.text "care", default: "", null: false
    t.text "notes"
    t.text "work"
    t.uuid "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_infos_on_product_id"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.decimal "selling_price", precision: 12, scale: 2, default: "0.0", null: false
    t.string "sku", default: "", null: false
    t.boolean "active", default: true, null: false
    t.uuid "sub_category_id"
    t.uuid "designer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_products_on_active", where: "active"
    t.index ["designer_id"], name: "index_products_on_designer_id"
    t.index ["name"], name: "index_products_on_name", using: :gin
    t.index ["selling_price"], name: "index_products_on_selling_price", using: :gin
    t.index ["sku"], name: "index_products_on_sku", unique: true
    t.index ["sub_category_id"], name: "index_products_on_sub_category_id"
  end

  create_table "push_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "token"
    t.text "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "request_chats", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "request_id"
    t.uuid "user_id"
    t.uuid "designer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["designer_id"], name: "index_request_chats_on_designer_id"
    t.index ["request_id"], name: "index_request_chats_on_request_id"
    t.index ["user_id"], name: "index_request_chats_on_user_id"
  end

  create_table "request_designers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "request_id"
    t.uuid "designer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "not_interested", default: false, null: false
    t.boolean "involved", default: false, null: false
    t.index ["designer_id"], name: "index_request_designers_on_designer_id"
    t.index ["involved"], name: "index_request_designers_on_involved", where: "involved"
    t.index ["not_interested"], name: "index_request_designers_on_not_interested", where: "(not_interested IS FALSE)"
    t.index ["request_id"], name: "index_request_designers_on_request_id"
  end

  create_table "request_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "image", default: "", null: false
    t.text "description", default: "", null: false
    t.string "color", default: "", null: false
    t.integer "height", default: 0, null: false
    t.integer "width", default: 0, null: false
    t.uuid "request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "serial_number"
    t.index ["request_id"], name: "index_request_images_on_request_id"
    t.index ["serial_number"], name: "index_request_images_on_serial_number", using: :gin
  end

  create_table "requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "size", default: "", null: false
    t.decimal "min_budget", precision: 9, scale: 2, default: "0.0", null: false
    t.decimal "max_budget", precision: 9, scale: 2, default: "0.0", null: false
    t.integer "timeline", default: 0, null: false
    t.text "description"
    t.uuid "user_id"
    t.uuid "sub_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "address_id"
    t.string "status"
    t.string "origin"
    t.boolean "hot"
    t.boolean "cold"
    t.boolean "warm"
    t.string "support_notes"
    t.string "urls", default: [], array: true
    t.index ["address_id"], name: "index_requests_on_address_id"
    t.index ["name"], name: "index_requests_on_name", using: :gin
    t.index ["origin"], name: "index_requests_on_origin", using: :gin
    t.index ["sub_category_id"], name: "index_requests_on_sub_category_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "search_suggestions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "serial_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sub_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "image", default: "", null: false
    t.uuid "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "measurement_image"
    t.integer "serial_no"
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

  create_table "support_chats", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "support_id"
    t.uuid "user_id"
    t.uuid "designer_id"
    t.boolean "responding"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["designer_id"], name: "index_support_chats_on_designer_id"
    t.index ["support_id"], name: "index_support_chats_on_support_id"
    t.index ["user_id"], name: "index_support_chats_on_user_id"
  end

  create_table "supports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "full_name", default: "", null: false
    t.string "mobile_number", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "devise_token"
    t.string "common_id"
    t.string "role"
    t.index ["confirmation_token"], name: "index_supports_on_confirmation_token", unique: true
    t.index ["email"], name: "index_supports_on_email", unique: true
    t.index ["reset_password_token"], name: "index_supports_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_supports_on_unlock_token", unique: true
  end

  create_table "top_query_suggestions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "serial_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_chat_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_favorite_designers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "designer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["designer_id"], name: "index_user_favorite_designers_on_designer_id"
    t.index ["user_id"], name: "index_user_favorite_designers_on_user_id"
  end

  create_table "user_favorite_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_user_favorite_products_on_product_id"
    t.index ["user_id"], name: "index_user_favorite_products_on_user_id"
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
    t.boolean "verified", default: true
    t.text "bio"
    t.text "devise_token"
    t.datetime "membership_start_date"
    t.boolean "redeem", default: false
    t.boolean "hot"
    t.boolean "cold"
    t.boolean "warm"
    t.string "support_notes"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "categories", "super_categories"
  add_foreign_key "designer_categorizations", "designers"
  add_foreign_key "designer_categorizations", "sub_categories"
  add_foreign_key "designer_finance_infos", "designers"
  add_foreign_key "designer_store_infos", "designers"
  add_foreign_key "offer_measurements", "offer_quotations"
  add_foreign_key "offer_quotation_chats", "designers"
  add_foreign_key "offer_quotation_chats", "offer_quotations"
  add_foreign_key "offer_quotation_chats", "users"
  add_foreign_key "offer_quotation_galleries", "offer_quotations"
  add_foreign_key "offer_quotations", "offers"
  add_foreign_key "offers", "designers"
  add_foreign_key "offers", "requests"
  add_foreign_key "order_measurements", "orders"
  add_foreign_key "order_options", "images"
  add_foreign_key "order_options", "offer_quotation_galleries"
  add_foreign_key "order_options", "orders"
  add_foreign_key "order_payments", "orders"
  add_foreign_key "order_payments", "users"
  add_foreign_key "order_status_logs", "orders"
  add_foreign_key "orders", "designers"
  add_foreign_key "orders", "offer_quotations"
  add_foreign_key "orders", "users"
  add_foreign_key "product_infos", "products"
  add_foreign_key "products", "designers"
  add_foreign_key "products", "sub_categories"
  add_foreign_key "request_chats", "designers"
  add_foreign_key "request_chats", "requests"
  add_foreign_key "request_chats", "users"
  add_foreign_key "request_designers", "designers"
  add_foreign_key "request_designers", "requests"
  add_foreign_key "request_images", "requests"
  add_foreign_key "requests", "addresses"
  add_foreign_key "requests", "sub_categories"
  add_foreign_key "requests", "users"
  add_foreign_key "sub_categories", "categories"
  add_foreign_key "user_favorite_designers", "designers"
  add_foreign_key "user_favorite_designers", "users"
  add_foreign_key "user_favorite_products", "products"
  add_foreign_key "user_favorite_products", "users"
  add_foreign_key "user_identities", "users"
end
