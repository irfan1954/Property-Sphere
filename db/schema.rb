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

ActiveRecord::Schema[7.1].define(version: 2024_12_02_112011) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "amenities", force: :cascade do |t|
    t.string "category"
    t.string "name"
    t.float "lat"
    t.float "long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "postcode"
    t.string "borough"
    t.string "layer_code"
    t.float "lat"
    t.float "long"
    t.float "crime"
    t.integer "rent_price"
    t.integer "purchase_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "demographic"
    t.string "constituency"
    t.string "afluence"
    t.string "raw_postcode"
  end

  create_table "properties", force: :cascade do |t|
    t.text "address"
    t.text "description"
    t.integer "bedrooms"
    t.integer "bathrooms"
    t.boolean "garden"
    t.text "image_urls", default: [], array: true
    t.string "council_tax"
    t.string "property_type"
    t.float "floor_area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.bigint "location_id"
    t.integer "price"
    t.string "freehold"
    t.index ["location_id"], name: "index_properties_on_location_id"
  end

  create_table "recommendations", force: :cascade do |t|
    t.string "comment"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "location_id"
    t.index ["location_id"], name: "index_recommendations_on_location_id"
    t.index ["user_id"], name: "index_recommendations_on_user_id"
  end

  create_table "saved_properties", force: :cascade do |t|
    t.text "comment"
    t.bigint "user_id", null: false
    t.bigint "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "contacted", default: false
    t.index ["property_id"], name: "index_saved_properties_on_property_id"
    t.index ["user_id"], name: "index_saved_properties_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "properties", "locations"
  add_foreign_key "recommendations", "locations"
  add_foreign_key "recommendations", "users"
  add_foreign_key "saved_properties", "properties"
  add_foreign_key "saved_properties", "users"
end
