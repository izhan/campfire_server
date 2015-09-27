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

ActiveRecord::Schema.define(version: 20150927080732) do

  create_table "calendar_lists", force: :cascade do |t|
    t.text     "json_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "calendar_lists", ["user_id"], name: "index_calendar_lists_on_user_id"

  create_table "calendars", force: :cascade do |t|
    t.integer  "calendar_list_id"
    t.text     "json_data"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "calendars", ["calendar_list_id"], name: "index_calendars_on_calendar_list_id"

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "access_token"
    t.string   "uid"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
