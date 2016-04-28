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

ActiveRecord::Schema.define(version: 20160426182115) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "instagram_photos", force: :cascade do |t|
    t.text     "instagram_id"
    t.text     "photo_url"
    t.text     "instagram_username"
    t.text     "instagram_profile_photo"
    t.text     "instagram_fullname"
    t.text     "caption"
    t.integer  "likes"
    t.datetime "post_time"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "settings", primary_key: "key", force: :cascade, id: false do |t|
    t.text "key"
    t.text "value"
  end

  create_table "user_accounts", force: :cascade do |t|
    t.integer  "account_type"
    t.string   "username"
    t.string   "fullname"
    t.string   "profile_picture_url"
    t.string   "auth_token"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

end
