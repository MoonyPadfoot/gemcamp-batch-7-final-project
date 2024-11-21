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

ActiveRecord::Schema[7.0].define(version: 2024_11_21_032042) do
  create_table "address_barangays", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "city_id"
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_address_barangays_on_city_id"
  end

  create_table "address_cities", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "province_id"
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["province_id"], name: "index_address_cities_on_province_id"
  end

  create_table "address_provinces", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "region_id"
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_address_provinces_on_region_id"
  end

  create_table "address_regions", charset: "utf8mb4", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banners", charset: "utf8mb4", force: :cascade do |t|
    t.string "preview"
    t.datetime "online_at"
    t.datetime "offline_at"
    t.integer "status", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "client_addresses", charset: "utf8mb4", force: :cascade do |t|
    t.integer "genre", default: 0
    t.string "name", default: ""
    t.text "street_address", null: false
    t.string "phone_number", null: false
    t.text "remark", default: ""
    t.boolean "is_default", default: false
    t.bigint "user_id"
    t.bigint "region_id"
    t.bigint "province_id"
    t.bigint "city_id"
    t.bigint "barangay_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["barangay_id"], name: "index_client_addresses_on_barangay_id"
    t.index ["city_id"], name: "index_client_addresses_on_city_id"
    t.index ["province_id"], name: "index_client_addresses_on_province_id"
    t.index ["region_id"], name: "index_client_addresses_on_region_id"
    t.index ["user_id"], name: "index_client_addresses_on_user_id"
  end

  create_table "item_category_ships", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_item_category_ships_on_category_id"
    t.index ["item_id"], name: "index_item_category_ships_on_item_id"
  end

  create_table "items", charset: "utf8mb4", force: :cascade do |t|
    t.string "image"
    t.string "name", null: false
    t.integer "quantity"
    t.integer "minimum_tickets"
    t.string "state"
    t.integer "batch_count"
    t.datetime "online_at"
    t.datetime "offline_at"
    t.datetime "start_at"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "news_tickers", charset: "utf8mb4", force: :cascade do |t|
    t.text "content"
    t.integer "status", default: 0
    t.bigint "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["admin_id"], name: "index_news_tickers_on_admin_id"
  end

  create_table "offers", charset: "utf8mb4", force: :cascade do |t|
    t.string "image"
    t.string "name"
    t.integer "status", default: 0
    t.decimal "amount", precision: 18, scale: 2, default: "0.0"
    t.integer "coin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "offer_id"
    t.string "serial_number"
    t.string "state"
    t.decimal "amount", precision: 18, scale: 2, default: "0.0"
    t.integer "coin", default: 0
    t.text "remarks"
    t.integer "genre", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offer_id"], name: "index_orders_on_offer_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "tickets", charset: "utf8mb4", force: :cascade do |t|
    t.integer "coins", default: 1
    t.integer "batch_count"
    t.string "serial_number"
    t.string "state"
    t.bigint "user_id"
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_tickets_on_item_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username"
    t.integer "role", default: 0
    t.string "phone_number"
    t.integer "coins", default: 0
    t.decimal "total_deposit", precision: 18, scale: 2, default: "0.0"
    t.integer "children_members", default: 0
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.bigint "parent_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "winners", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "ticket_id"
    t.bigint "user_id"
    t.bigint "address_id"
    t.integer "item_batch_count"
    t.string "state"
    t.decimal "price", precision: 18, scale: 2, default: "0.0"
    t.datetime "paid_at"
    t.bigint "admin_id"
    t.string "picture"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_winners_on_address_id"
    t.index ["item_id"], name: "index_winners_on_item_id"
    t.index ["ticket_id"], name: "index_winners_on_ticket_id"
    t.index ["user_id"], name: "index_winners_on_user_id"
  end

end
