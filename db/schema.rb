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

ActiveRecord::Schema.define(version: 20150209095949) do

  create_table "playlists", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skips", force: true do |t|
    t.integer  "skipper_id"
    t.integer  "skipped_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skips", ["skipped_id"], name: "index_skips_on_skipped_id"
  add_index "skips", ["skipper_id", "skipped_id"], name: "index_skips_on_skipper_id_and_skipped_id"
  add_index "skips", ["skipper_id"], name: "index_skips_on_skipper_id"

  create_table "tracks", force: true do |t|
    t.string   "name"
    t.string   "artist"
    t.string   "album"
    t.string   "uri"
    t.integer  "user_id"
    t.integer  "playlist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "spotify_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "skip_count",             default: 1
    t.integer  "play_count",             default: 0
    t.integer  "pause_count",            default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
