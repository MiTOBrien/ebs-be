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

ActiveRecord::Schema[8.0].define(version: 2025_09_10_181849) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "parent_id"
    t.index ["parent_id"], name: "index_genres_on_parent_id"
  end

  create_table "pricing_tiers", force: :cascade do |t|
    t.integer "word_count"
    t.integer "price_cents"
    t.string "currency"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pricing_tiers_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "subscription_type"
    t.text "status"
    t.text "stripe_subscription_id"
    t.text "stripe_customer_id"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.integer "amount_cents"
    t.text "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "user_genres", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_user_genres_on_genre_id"
    t.index ["user_id"], name: "index_user_genres_on_user_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "user_subgenres", force: :cascade do |t|
    t.bigint "user_genre_id", null: false
    t.bigint "subgenre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subgenre_id"], name: "index_user_subgenres_on_subgenre_id"
    t.index ["user_genre_id"], name: "index_user_subgenres_on_user_genre_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.boolean "professional"
    t.boolean "acknowledgement"
    t.text "bio"
    t.string "profile_picture"
    t.string "jti", null: false
    t.string "username"
    t.string "facebook"
    t.string "instagram"
    t.string "x"
    t.boolean "charges_for_services"
    t.text "subscription_type"
    t.text "subscription_status"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "genres", "genres", column: "parent_id"
  add_foreign_key "pricing_tiers", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "user_genres", "genres"
  add_foreign_key "user_genres", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "user_subgenres", "genres", column: "subgenre_id"
  add_foreign_key "user_subgenres", "user_genres"
end
