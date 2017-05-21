# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151103052735) do

  create_table "actors", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "user_id",          limit: 4,                   null: false
    t.integer  "original_post_id", limit: 8,                   null: false
    t.integer  "post_id",          limit: 4,                   null: false
    t.integer  "actor_id",         limit: 4
    t.integer  "width",            limit: 4
    t.integer  "height",           limit: 4
    t.string   "url",              limit: 255,                 null: false
    t.string   "image",            limit: 255
    t.string   "average_hash",     limit: 255
    t.string   "color_hash",       limit: 255
    t.boolean  "has_downloaded",   limit: 1,   default: false, null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "photos", ["post_id"], name: "post_id", using: :btree
  add_index "photos", ["user_id", "actor_id"], name: "user_id_and_actor_id", using: :btree
  add_index "photos", ["user_id", "url"], name: "user_id_and_url", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id",     limit: 4,               null: false
    t.integer  "original_id", limit: 8,               null: false
    t.string   "url",         limit: 255,             null: false
    t.datetime "posted_at",                           null: false
    t.integer  "photo_count", limit: 4,   default: 1, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "posts", ["user_id", "original_id"], name: "user_id_and_original_id", unique: true, using: :btree
  add_index "posts", ["user_id", "posted_at"], name: "user_id_and_posted_at", using: :btree
  add_index "posts", ["user_id", "url"], name: "user_id_and_url", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",               limit: 255, null: false
    t.string   "provider",           limit: 255, null: false
    t.string   "provider_user_id",   limit: 255, null: false
    t.string   "oauth_token",        limit: 255, null: false
    t.string   "oauth_token_secret", limit: 255, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "users", ["provider", "provider_user_id"], name: "provider_and_provider_user_id", unique: true, using: :btree

end
