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

ActiveRecord::Schema.define(version: 2015_03_11_151313) do

  create_table "actors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
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

  create_table "posts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
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

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
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
