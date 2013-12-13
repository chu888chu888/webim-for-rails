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

ActiveRecord::Schema.define(version: 20131212044047) do

  create_table "webim_histories", force: true do |t|
    t.integer  "send"
    t.string   "type"
    t.string   "to"
    t.string   "from"
    t.string   "nick"
    t.string   "body"
    t.string   "style"
    t.float    "timestamp"
    t.integer  "todel"
    t.integer  "fromdel"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "webim_histories_raw", force: true do |t|
    t.boolean "send"
    t.string  "type",       limit: 20
    t.string  "to",         limit: 50,                  null: false
    t.string  "from",       limit: 50,                  null: false
    t.string  "nick",       limit: 20
    t.text    "body"
    t.string  "style",      limit: 150
    t.float   "timestamp"
    t.boolean "todel",                  default: false, null: false
    t.boolean "fromdel",                default: false, null: false
    t.date    "created_at"
    t.date    "updated_at"
  end

  add_index "webim_histories_raw", ["from"], name: "from", using: :btree
  add_index "webim_histories_raw", ["send"], name: "send", using: :btree
  add_index "webim_histories_raw", ["timestamp"], name: "timestamp", using: :btree
  add_index "webim_histories_raw", ["to"], name: "to", using: :btree

  create_table "webim_settings", force: true do |t|
    t.string   "uid"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "webim_settings_raw", force: true do |t|
    t.string   "uid",        limit: 40, default: "", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
