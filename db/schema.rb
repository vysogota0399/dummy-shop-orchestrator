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

ActiveRecord::Schema[7.0].define(version: 2023_07_09_125314) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "item_reviews", force: :cascade do |t|
    t.bigint "item_id"
    t.index ["item_id"], name: "index_item_reviews_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer "kind"
    t.integer "cost_cops"
    t.integer "weight"
    t.integer "remainder"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "provider_id"
    t.index ["provider_id"], name: "index_items_on_provider_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "item_id"
    t.integer "cost_cops"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_order_items_on_item_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "assembler_id"
    t.bigint "courier_id"
    t.integer "cost_cops"
    t.string "customer_email"
    t.string "address"
    t.string "front_door"
    t.string "floor"
    t.string "intercom"
    t.boolean "no_hand"
    t.string "state"
    t.datetime "delivered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_providers_on_email", unique: true
  end

  add_foreign_key "item_reviews", "items"
  add_foreign_key "items", "providers"
end
