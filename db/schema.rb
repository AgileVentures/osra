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

ActiveRecord::Schema.define(version: 20141229224941) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.integer  "province_id"
    t.string   "city",                       limit: 255
    t.string   "neighborhood",               limit: 255
    t.string   "street",                     limit: 255
    t.string   "details",                    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "orphan_original_address_id"
    t.integer  "orphan_current_address_id"
  end

  add_index "addresses", ["orphan_current_address_id"], name: "index_addresses_on_orphan_current_address_id", using: :btree
  add_index "addresses", ["orphan_original_address_id"], name: "index_addresses_on_orphan_original_address_id", using: :btree
  add_index "addresses", ["province_id"], name: "index_addresses_on_province_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "branches", force: :cascade do |t|
    t.integer  "code"
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "branches", ["code"], name: "index_branches_on_code", unique: true, using: :btree

  create_table "organizations", force: :cascade do |t|
    t.integer  "code"
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["code"], name: "index_organizations_on_code", unique: true, using: :btree
  add_index "organizations", ["name"], name: "index_organizations_on_name", unique: true, using: :btree

  create_table "orphan_lists", force: :cascade do |t|
    t.string   "osra_num",                 limit: 255
    t.integer  "partner_id"
    t.integer  "orphan_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sequential_id"
    t.string   "spreadsheet_file_name",    limit: 255
    t.string   "spreadsheet_content_type", limit: 255
    t.integer  "spreadsheet_file_size"
    t.datetime "spreadsheet_updated_at"
  end

  add_index "orphan_lists", ["osra_num"], name: "index_orphan_lists_on_osra_num", unique: true, using: :btree
  add_index "orphan_lists", ["partner_id"], name: "index_orphan_lists_on_partner_id", using: :btree
  add_index "orphan_lists", ["sequential_id"], name: "index_orphan_lists_on_sequential_id", using: :btree

  create_table "orphan_sponsorship_statuses", force: :cascade do |t|
    t.integer  "code"
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orphan_sponsorship_statuses", ["code"], name: "index_orphan_sponsorship_statuses_on_code", unique: true, using: :btree
  add_index "orphan_sponsorship_statuses", ["name"], name: "index_orphan_sponsorship_statuses_on_name", unique: true, using: :btree

  create_table "orphan_statuses", force: :cascade do |t|
    t.integer "code"
    t.string  "name", limit: 255
  end

  add_index "orphan_statuses", ["code"], name: "index_orphan_statuses_on_code", unique: true, using: :btree
  add_index "orphan_statuses", ["name"], name: "index_orphan_statuses_on_name", unique: true, using: :btree

  create_table "orphans", force: :cascade do |t|
    t.string   "name",                            limit: 255
    t.boolean  "father_is_martyr"
    t.string   "father_occupation",               limit: 255
    t.string   "father_place_of_death",           limit: 255
    t.string   "father_cause_of_death",           limit: 255
    t.date     "father_date_of_death"
    t.string   "mother_name",                     limit: 255
    t.boolean  "mother_alive"
    t.date     "date_of_birth"
    t.string   "gender",                          limit: 255
    t.string   "health_status",                   limit: 255
    t.string   "schooling_status",                limit: 255
    t.boolean  "goes_to_school"
    t.string   "guardian_name",                   limit: 255
    t.string   "guardian_relationship",           limit: 255
    t.integer  "guardian_id_num"
    t.string   "contact_number",                  limit: 255
    t.string   "alt_contact_number",              limit: 255
    t.boolean  "sponsored_by_another_org"
    t.string   "another_org_sponsorship_details", limit: 255
    t.integer  "minor_siblings_count"
    t.integer  "sponsored_minor_siblings_count"
    t.string   "comments",                        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "orphan_status_id"
    t.integer  "orphan_sponsorship_status_id"
    t.string   "priority",                        limit: 255
    t.integer  "sequential_id"
    t.string   "osra_num",                        limit: 255
    t.integer  "orphan_list_id"
    t.integer  "province_code"
    t.boolean  "father_alive"
    t.string   "father_given_name",               limit: 255, null: false
    t.string   "family_name",                     limit: 255, null: false
  end

  add_index "orphans", ["orphan_list_id"], name: "index_orphans_on_orphan_list_id", using: :btree
  add_index "orphans", ["orphan_sponsorship_status_id"], name: "index_orphans_on_orphan_sponsorship_status_id", using: :btree
  add_index "orphans", ["orphan_status_id"], name: "index_orphans_on_orphan_status_id", using: :btree
  add_index "orphans", ["osra_num"], name: "index_orphans_on_osra_num", unique: true, using: :btree
  add_index "orphans", ["priority"], name: "index_orphans_on_priority", using: :btree
  add_index "orphans", ["sequential_id"], name: "index_orphans_on_sequential_id", using: :btree

  create_table "partners", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "region",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact_details", limit: 255
    t.integer  "province_id"
    t.integer  "status_id"
    t.date     "start_date"
    t.string   "osra_num",        limit: 255
    t.integer  "sequential_id"
  end

  add_index "partners", ["name"], name: "index_partners_on_name", unique: true, using: :btree
  add_index "partners", ["osra_num"], name: "index_partners_on_osra_num", unique: true, using: :btree
  add_index "partners", ["province_id"], name: "index_partners_on_province_id", using: :btree
  add_index "partners", ["sequential_id"], name: "index_partners_on_sequential_id", using: :btree
  add_index "partners", ["status_id"], name: "index_partners_on_status_id", using: :btree

  create_table "pending_orphan_lists", force: :cascade do |t|
    t.string   "spreadsheet_file_name",    limit: 255
    t.string   "spreadsheet_content_type", limit: 255
    t.integer  "spreadsheet_file_size"
    t.datetime "spreadsheet_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pending_orphans", force: :cascade do |t|
    t.integer "pending_orphan_list_id"
    t.string  "name",                            limit: 255
    t.string  "father_is_martyr",                limit: 255
    t.string  "father_occupation",               limit: 255
    t.string  "father_place_of_death",           limit: 255
    t.string  "father_cause_of_death",           limit: 255
    t.string  "father_date_of_death",            limit: 255
    t.string  "mother_name",                     limit: 255
    t.string  "mother_alive",                    limit: 255
    t.string  "date_of_birth",                   limit: 255
    t.string  "gender",                          limit: 255
    t.string  "health_status",                   limit: 255
    t.string  "schooling_status",                limit: 255
    t.string  "goes_to_school",                  limit: 255
    t.string  "guardian_name",                   limit: 255
    t.string  "guardian_relationship",           limit: 255
    t.string  "guardian_id_num",                 limit: 255
    t.string  "original_address_province",       limit: 255
    t.string  "original_address_city",           limit: 255
    t.string  "original_address_neighborhood",   limit: 255
    t.string  "original_address_street",         limit: 255
    t.string  "original_address_details",        limit: 255
    t.string  "current_address_province",        limit: 255
    t.string  "current_address_city",            limit: 255
    t.string  "current_address_neighborhood",    limit: 255
    t.string  "current_address_street",          limit: 255
    t.string  "current_address_details",         limit: 255
    t.string  "contact_number",                  limit: 255
    t.string  "alt_contact_number",              limit: 255
    t.string  "sponsored_by_another_org",        limit: 255
    t.string  "another_org_sponsorship_details", limit: 255
    t.string  "minor_siblings_count",            limit: 255
    t.string  "sponsored_minor_siblings_count",  limit: 255
    t.string  "comments",                        limit: 255
    t.boolean "father_alive"
    t.string  "father_given_name",               limit: 255
    t.string  "family_name",                     limit: 255
  end

  add_index "pending_orphans", ["pending_orphan_list_id"], name: "index_pending_orphans_on_pending_orphan_list_id", using: :btree

  create_table "provinces", force: :cascade do |t|
    t.integer  "code"
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provinces", ["code"], name: "index_provinces_on_code", unique: true, using: :btree
  add_index "provinces", ["name"], name: "index_provinces_on_name", unique: true, using: :btree

  create_table "sponsor_types", force: :cascade do |t|
    t.integer "code"
    t.string  "name", limit: 255
  end

  add_index "sponsor_types", ["code"], name: "index_sponsor_types_on_code", unique: true, using: :btree
  add_index "sponsor_types", ["name"], name: "index_sponsor_types_on_name", unique: true, using: :btree

  create_table "sponsors", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.string   "address",                  limit: 255
    t.string   "country",                  limit: 255
    t.string   "email",                    limit: 255
    t.string   "contact1",                 limit: 255
    t.string   "contact2",                 limit: 255
    t.string   "additional_info",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
    t.date     "start_date"
    t.integer  "sponsor_type_id"
    t.string   "gender",                   limit: 255
    t.integer  "branch_id"
    t.integer  "organization_id"
    t.string   "osra_num",                 limit: 255
    t.integer  "sequential_id"
    t.integer  "requested_orphan_count"
    t.boolean  "request_fulfilled",                    default: false, null: false
    t.integer  "agent_id"
    t.string   "city",                     limit: 255
    t.string   "payment_plan",             limit: 255, default: "",    null: false
    t.integer  "active_sponsorship_count",             default: 0
  end

  add_index "sponsors", ["agent_id"], name: "index_sponsors_on_agent_id", using: :btree
  add_index "sponsors", ["branch_id"], name: "index_sponsors_on_branch_id", using: :btree
  add_index "sponsors", ["organization_id"], name: "index_sponsors_on_organization_id", using: :btree
  add_index "sponsors", ["osra_num"], name: "index_sponsors_on_osra_num", unique: true, using: :btree
  add_index "sponsors", ["request_fulfilled"], name: "index_sponsors_on_request_fulfilled", using: :btree
  add_index "sponsors", ["sequential_id"], name: "index_sponsors_on_sequential_id", using: :btree
  add_index "sponsors", ["sponsor_type_id"], name: "index_sponsors_on_sponsor_type_id", using: :btree
  add_index "sponsors", ["status_id"], name: "index_sponsors_on_status_id", using: :btree

  create_table "sponsorships", force: :cascade do |t|
    t.integer  "sponsor_id"
    t.integer  "orphan_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: true, null: false
  end

  add_index "sponsorships", ["active"], name: "index_sponsorships_on_active", using: :btree
  add_index "sponsorships", ["orphan_id"], name: "index_sponsorships_on_orphan_id", using: :btree
  add_index "sponsorships", ["sponsor_id"], name: "index_sponsorships_on_sponsor_id", using: :btree

  create_table "statuses", force: :cascade do |t|
    t.integer "code"
    t.string  "name", limit: 255
  end

  add_index "statuses", ["code"], name: "index_statuses_on_code", unique: true, using: :btree
  add_index "statuses", ["name"], name: "index_statuses_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_name",  limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["user_name"], name: "index_users_on_user_name", unique: true, using: :btree

end
