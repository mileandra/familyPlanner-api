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

ActiveRecord::Schema.define(version: 20160125202655) do

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "groups", ["owner_id"], name: "index_groups_on_owner_id"

  create_table "invitations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "invitations", ["group_id"], name: "index_invitations_on_group_id"
  add_index "invitations", ["user_id"], name: "index_invitations_on_user_id"

  create_table "messages", force: :cascade do |t|
    t.text     "message"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "subject"
    t.integer  "responds_id"
    t.boolean  "read",        default: false
  end

  add_index "messages", ["group_id"], name: "index_messages_on_group_id"
  add_index "messages", ["user_id"], name: "index_messages_on_user_id"

  create_table "todo_user_archives", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "todo_id"
    t.boolean  "archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "todo_user_archives", ["todo_id"], name: "index_todo_user_archives_on_todo_id"
  add_index "todo_user_archives", ["user_id"], name: "index_todo_user_archives_on_user_id"

  create_table "todos", force: :cascade do |t|
    t.string   "title"
    t.boolean  "completed",  default: false
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "creator_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "todos", ["creator_id"], name: "index_todos_on_creator_id"
  add_index "todos", ["group_id"], name: "index_todos_on_group_id"
  add_index "todos", ["user_id"], name: "index_todos_on_user_id"

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "auth_token"
    t.integer  "group_id"
    t.string   "name"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["group_id"], name: "index_users_on_group_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
