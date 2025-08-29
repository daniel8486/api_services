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

ActiveRecord::Schema[8.0].define(version: 2025_07_30_191304) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "access_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip"
    t.string "region"
    t.datetime "accessed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_access_logs_on_user_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "code_postal"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.string "street"
    t.string "complement"
    t.string "point_reference"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id", null: false
    t.index ["client_id"], name: "index_addresses_on_client_id"
  end

  create_table "affiliations", force: :cascade do |t|
    t.string "nm_mother"
    t.string "nm_father"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id", null: false
    t.index ["client_id"], name: "index_affiliations_on_client_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "company_id", null: false
    t.bigint "plan_id", null: false
    t.decimal "discount_percentage"
    t.string "payment_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_campaigns_on_company_id"
    t.index ["plan_id"], name: "index_campaigns_on_plan_id"
  end

  create_table "cash_register_transactions", force: :cascade do |t|
    t.bigint "cash_register_id", null: false
    t.bigint "installment_id", null: false
    t.bigint "client_id", null: false
    t.decimal "valor"
    t.string "tipo"
    t.datetime "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cash_register_id"], name: "index_cash_register_transactions_on_cash_register_id"
    t.index ["client_id"], name: "index_cash_register_transactions_on_client_id"
    t.index ["installment_id"], name: "index_cash_register_transactions_on_installment_id"
  end

  create_table "cash_registers", force: :cascade do |t|
    t.decimal "opening_value"
    t.decimal "closing_value"
    t.datetime "opened_at"
    t.datetime "closed_at"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cash_registers_on_user_id"
  end

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

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "cpf"
    t.string "rg"
    t.date "dt_expedition"
    t.string "organ"
    t.string "phone"
    t.string "cellphone"
    t.date "dt_born"
    t.string "nationality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", null: false
    t.index ["company_id"], name: "index_clients_on_company_id"
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

  create_table "contracts", force: :cascade do |t|
    t.integer "client_id"
    t.bigint "plan_id", null: false
    t.bigint "campaign_id"
    t.string "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "valor"
    t.integer "parcelas"
    t.date "data_contrato"
    t.bigint "company_id", null: false
    t.index ["campaign_id"], name: "index_contracts_on_campaign_id"
    t.index ["company_id"], name: "index_contracts_on_company_id"
    t.index ["plan_id"], name: "index_contracts_on_plan_id"
  end

  create_table "degree_dependents", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dependents", force: :cascade do |t|
    t.string "name"
    t.string "cpf"
    t.date "dt_born"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id", null: false
    t.bigint "degree_dependent_id", null: false
    t.index ["client_id"], name: "index_dependents_on_client_id"
    t.index ["degree_dependent_id"], name: "index_dependents_on_degree_dependent_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "document_n"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document"
    t.bigint "type_document_id", null: false
    t.string "files"
    t.integer "client_id"
    t.index ["type_document_id"], name: "index_documents_on_type_document_id"
  end

  create_table "email_deliveries", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "contract_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.string "error_message"
    t.index ["client_id"], name: "index_email_deliveries_on_client_id"
    t.index ["contract_id"], name: "index_email_deliveries_on_contract_id"
  end

  create_table "installments", force: :cascade do |t|
    t.bigint "contract_id", null: false
    t.integer "numero"
    t.decimal "valor"
    t.date "vencimento"
    t.date "data_pagamento"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_installments_on_contract_id"
  end

  create_table "money_boxes", force: :cascade do |t|
    t.decimal "opening_value"
    t.decimal "closing_value"
    t.bigint "user_id", null: false
    t.decimal "withdrawal_cash"
    t.text "observation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_money_boxes_on_user_id"
  end

  create_table "neighborhoods", force: :cascade do |t|
    t.string "name"
    t.bigint "city_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "locality"
    t.index ["city_id"], name: "index_neighborhoods_on_city_id"
  end

  create_table "pending_import_tables", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pending_import_tables_on_user_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_plans_on_company_id"
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

  create_table "type_documents", force: :cascade do |t|
    t.string "name"
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

  add_foreign_key "access_logs", "users"
  add_foreign_key "addresses", "clients"
  add_foreign_key "affiliations", "clients"
  add_foreign_key "campaigns", "companies"
  add_foreign_key "campaigns", "plans"
  add_foreign_key "cash_register_transactions", "cash_registers"
  add_foreign_key "cash_register_transactions", "clients"
  add_foreign_key "cash_register_transactions", "installments"
  add_foreign_key "cash_registers", "users"
  add_foreign_key "cities", "states"
  add_foreign_key "clients", "companies"
  add_foreign_key "contracts", "campaigns"
  add_foreign_key "contracts", "clients"
  add_foreign_key "contracts", "companies"
  add_foreign_key "contracts", "plans"
  add_foreign_key "dependents", "clients"
  add_foreign_key "dependents", "degree_dependents"
  add_foreign_key "documents", "type_documents"
  add_foreign_key "email_deliveries", "clients"
  add_foreign_key "email_deliveries", "contracts"
  add_foreign_key "installments", "contracts"
  add_foreign_key "money_boxes", "users"
  add_foreign_key "neighborhoods", "cities"
  add_foreign_key "pending_import_tables", "users"
  add_foreign_key "plans", "companies"
  add_foreign_key "users", "companies"
  add_foreign_key "zips", "cities"
  add_foreign_key "zips", "neighborhoods"
end
