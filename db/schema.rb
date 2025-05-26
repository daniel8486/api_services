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

ActiveRecord::Schema[8.0].define(version: 2025_05_26_162552) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cities", force: :cascade do |t|
    t.integer "code"
    t.string "name"
    t.bigint "state_id", null: false
    t.float "latitude"
    t.float "longitude"
    t.boolean "capital"
    t.string "ddd"
    t.string "timezone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cep_start"
    t.string "cep_end"
    t.string "name_ibge"
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name_fantasy"
    t.string "size"
    t.string "registration_status_date"
    t.string "opening_date"
    t.string "public_place"
    t.integer "number"
    t.string "complement"
    t.string "code_postal"
    t.string "neighborhood"
    t.string "municipality"
    t.string "uf"
    t.string "email"
    t.string "phone"
    t.string "country"
  end

  create_table "neighborhoods", force: :cascade do |t|
    t.string "name"
    t.bigint "city_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locality"
    t.index ["city_id"], name: "index_neighborhoods_on_city_id"
  end

  create_table "states", force: :cascade do |t|
    t.integer "code"
    t.string "name"
    t.string "acronym"
    t.string "region"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "jti", null: false
    t.string "cpf"
    t.integer "role", default: 0, null: false
    t.string "avatar"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "zips", force: :cascade do |t|
    t.string "code"
    t.string "street"
    t.bigint "neighborhood_id", null: false
    t.bigint "city_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "zone"
    t.index ["city_id"], name: "index_zips_on_city_id"
    t.index ["neighborhood_id"], name: "index_zips_on_neighborhood_id"
  end

  add_foreign_key "cities", "states"
  add_foreign_key "neighborhoods", "cities"
  add_foreign_key "users", "companies"
  add_foreign_key "zips", "cities"
  add_foreign_key "zips", "neighborhoods"
end
