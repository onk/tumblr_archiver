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

ActiveRecord::Schema.define(version: 2015_03_11_151313) do

  create_table "actors", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "user_id", null: false
    t.bigint "original_post_id", null: false
    t.integer "post_id", null: false
    t.integer "actor_id"
    t.integer "width"
    t.integer "height"
    t.string "url", null: false
    t.string "image"
    t.string "average_hash"
    t.boolean "has_downloaded", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "post_id"
    t.index ["user_id", "actor_id"], name: "user_id_and_actor_id"
    t.index ["user_id", "url"], name: "user_id_and_url"
  end

  create_table "posts", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "user_id", null: false
    t.bigint "original_id", null: false
    t.string "url", null: false
    t.datetime "posted_at", null: false
    t.integer "photo_count", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "original_id"], name: "user_id_and_original_id", unique: true
    t.index ["user_id", "posted_at"], name: "user_id_and_posted_at"
    t.index ["user_id", "url"], name: "user_id_and_url"
  end

  create_table "users", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "provider", null: false
    t.string "provider_user_id", null: false
    t.string "oauth_token", null: false
    t.string "oauth_token_secret", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "provider_user_id"], name: "provider_and_provider_user_id", unique: true
  end

end
