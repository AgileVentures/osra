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

ActiveRecord::Schema.define(version: 20140907135744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: true do |t|
    t.integer  "province_id"
    t.string   "city"
    t.string   "neighborhood"
    t.string   "street"
    t.string   "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "orphan_original_address_id"
    t.integer  "orphan_current_address_id"
  end

  create_table "admin_users", force: true do |t|
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
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "branches", force: true do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orphans", force: true do |t|
    t.string   "name"
    t.string   "father_name"
    t.boolean  "father_is_martyr"
    t.string   "father_occupation"
    t.string   "father_place_of_death"
    t.string   "father_cause_of_death"
    t.date     "father_date_of_death"
    t.string   "mother_name"
    t.boolean  "mother_alive"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "health_status"
    t.string   "schooling_status"
    t.boolean  "goes_to_school"
    t.string   "guardian_name"
    t.string   "guardian_relationship"
    t.integer  "guardian_id"
    t.string   "contact_number"
    t.string   "alt_contact_number"
    t.boolean  "sponsored_by_another_org"
    t.string   "another_org_sponsorship_details"
    t.integer  "minor_siblings_count"
    t.integer  "sponsored_minor_siblings_count"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partners", force: true do |t|
    t.string   "name"
    t.string   "region"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact_details"
    t.integer  "province_id"
    t.integer  "status_id"
    t.date     "start_date"
    t.string   "osra_num"
    t.integer  "sequential_id"
  end

  add_index "partners", ["province_id"], name: "index_partners_on_province_id", using: :btree
  add_index "partners", ["status_id"], name: "index_partners_on_status_id", using: :btree

  create_table "provinces", force: true do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsor_types", force: true do |t|
    t.integer "code"
    t.string  "name"
  end

  create_table "sponsors", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "country"
    t.string   "email"
    t.string   "contact1"
    t.string   "contact2"
    t.string   "additional_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
    t.date     "start_date"
    t.integer  "sponsor_type_id"
    t.string   "gender"
    t.integer  "branch_id"
  end

  add_index "sponsors", ["branch_id"], name: "index_sponsors_on_branch_id", using: :btree
  add_index "sponsors", ["sponsor_type_id"], name: "index_sponsors_on_sponsor_type_id", using: :btree
  add_index "sponsors", ["status_id"], name: "index_sponsors_on_status_id", using: :btree

  create_table "statuses", force: true do |t|
    t.integer "code"
    t.string  "name"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
