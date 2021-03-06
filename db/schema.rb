# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_29_103352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "alm_roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_alm_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_alm_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_alm_roles_on_resource_type_and_resource_id"
  end

  create_table "alm_users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "email"
    t.string "username"
    t.string "verification_code"
    t.boolean "is_verified", default: false
    t.json "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "guest", default: false
    t.integer "account_type"
    t.string "question"
    t.datetime "birthdate"
    t.string "birthplace"
    t.string "address"
    t.boolean "hideBirthdate"
    t.boolean "hideBirthplace"
    t.boolean "hideEmail"
    t.boolean "hideAddress"
    t.boolean "hidePhonenumber"
    t.string "google_id"
    t.string "apple_uid"
    t.string "facebook_id"
    t.string "device_token"
    t.boolean "password_update", default: false
    t.string "platform_account_customer"
    t.string "connected_account_customer"
    t.index ["confirmation_token"], name: "index_alm_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_alm_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_alm_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_alm_users_on_uid_and_provider", unique: true
  end

  create_table "alm_users_alm_roles", id: false, force: :cascade do |t|
    t.bigint "alm_user_id"
    t.bigint "alm_role_id"
    t.index ["alm_role_id"], name: "index_alm_users_alm_roles_on_alm_role_id"
    t.index ["alm_user_id", "alm_role_id"], name: "index_alm_users_alm_roles_on_alm_user_id_and_alm_role_id"
    t.index ["alm_user_id"], name: "index_alm_users_alm_roles_on_alm_user_id"
  end

  create_table "blms", force: :cascade do |t|
    t.string "location"
    t.string "precinct"
    t.datetime "dob"
    t.datetime "rip"
    t.string "country"
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.text "description"
    t.string "privacy"
    t.float "longitude"
    t.float "latitude"
    t.string "stripe_connect_account_id"
    t.boolean "hideFamily"
    t.boolean "hideFriends"
    t.boolean "hideFollowers"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "account_type", null: false
    t.bigint "account_id", null: false
    t.index ["account_type", "account_id"], name: "index_comments_on_account_type_and_account_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "commentslikes", force: :cascade do |t|
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "account_type", null: false
    t.bigint "account_id", null: false
    t.index ["account_type", "account_id"], name: "index_commentslikes_on_account_type_and_account_id"
    t.index ["commentable_type", "commentable_id"], name: "index_commentslikes_on_commentable_type_and_commentable_id"
  end

  create_table "followers", force: :cascade do |t|
    t.string "page_type", null: false
    t.bigint "page_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "account_type", null: false
    t.bigint "account_id", null: false
    t.index ["account_type", "account_id"], name: "index_followers_on_account_type_and_account_id"
    t.index ["page_type", "page_id"], name: "index_followers_on_page_type_and_page_id"
  end

  create_table "memorials", force: :cascade do |t|
    t.string "birthplace"
    t.datetime "dob"
    t.datetime "rip"
    t.string "cemetery"
    t.string "country"
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "privacy"
    t.float "longitude"
    t.float "latitude"
    t.string "stripe_connect_account_id"
    t.boolean "hideFamily"
    t.boolean "hideFriends"
    t.boolean "hideFollowers"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "read"
    t.string "action"
    t.integer "postId"
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "actor_type", null: false
    t.bigint "actor_id", null: false
    t.string "notif_type"
    t.index ["actor_type", "actor_id"], name: "index_notifications_on_actor_type_and_actor_id"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient_type_and_recipient_id"
  end

  create_table "notifsettings", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "newMemorial"
    t.boolean "newActivities"
    t.boolean "postLikes"
    t.boolean "postComments"
    t.boolean "addFamily"
    t.boolean "addFriends"
    t.boolean "addAdmin"
    t.string "account_type"
    t.bigint "account_id"
    t.index ["account_type", "account_id"], name: "index_notifsettings_on_account_type_and_account_id"
  end

  create_table "pageowners", force: :cascade do |t|
    t.string "page_type", null: false
    t.bigint "page_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "view"
    t.string "account_type"
    t.bigint "account_id"
    t.index ["account_type", "account_id"], name: "index_pageowners_on_account_type_and_account_id"
    t.index ["page_type", "page_id"], name: "index_pageowners_on_page_type_and_page_id"
  end

  create_table "paypal_accounts", force: :cascade do |t|
    t.string "paypal_user_id"
    t.string "name"
    t.string "given_name"
    t.string "family_name"
    t.string "payer_id"
    t.string "address", default: [], array: true
    t.boolean "verified_account"
    t.string "emails"
    t.string "paypalable_type"
    t.bigint "paypalable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["paypalable_type", "paypalable_id"], name: "index_paypal_accounts_on_paypalable_type_and_paypalable_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "body"
    t.string "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "latitude"
    t.float "longitude"
    t.string "page_type", null: false
    t.bigint "page_id", null: false
    t.string "account_type"
    t.bigint "account_id"
    t.index ["account_type", "account_id"], name: "index_posts_on_account_type_and_account_id"
    t.index ["page_type", "page_id"], name: "index_posts_on_page_type_and_page_id"
  end

  create_table "postslikes", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "account_type"
    t.bigint "account_id"
    t.index ["account_type", "account_id"], name: "index_postslikes_on_account_type_and_account_id"
    t.index ["post_id"], name: "index_postslikes_on_post_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.string "page_type", null: false
    t.bigint "page_id", null: false
    t.string "relationship"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "account_type"
    t.bigint "account_id"
    t.index ["account_type", "account_id"], name: "index_relationships_on_account_type_and_account_id"
    t.index ["page_type", "page_id"], name: "index_relationships_on_page_type_and_page_id"
  end

  create_table "replies", force: :cascade do |t|
    t.bigint "comment_id", null: false
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "account_type", null: false
    t.bigint "account_id", null: false
    t.index ["account_type", "account_id"], name: "index_replies_on_account_type_and_account_id"
    t.index ["comment_id"], name: "index_replies_on_comment_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "subject"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reportable_type", null: false
    t.bigint "reportable_id", null: false
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable_type_and_reportable_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "shares", force: :cascade do |t|
    t.integer "user_id"
    t.integer "content_type"
    t.integer "content_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tagpeople", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "account_type"
    t.bigint "account_id"
    t.index ["account_type", "account_id"], name: "index_tagpeople_on_account_type_and_account_id"
    t.index ["post_id"], name: "index_tagpeople_on_post_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "page_type", null: false
    t.bigint "page_id", null: false
    t.float "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "account_type", null: false
    t.bigint "account_id", null: false
    t.string "status", default: "pending"
    t.index ["account_type", "account_id"], name: "index_transactions_on_account_type_and_account_id"
    t.index ["page_type", "page_id"], name: "index_transactions_on_page_type_and_page_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "email"
    t.string "username"
    t.string "verification_code"
    t.boolean "is_verified"
    t.text "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "guest", default: false
    t.integer "account_type"
    t.string "question"
    t.datetime "birthdate"
    t.string "birthplace"
    t.string "address"
    t.boolean "hideBirthdate"
    t.boolean "hideBirthplace"
    t.boolean "hideEmail"
    t.boolean "hideAddress"
    t.boolean "hidePhonenumber"
    t.string "google_id"
    t.string "apple_uid"
    t.string "facebook_id"
    t.string "device_token"
    t.boolean "password_update", default: false
    t.string "platform_account_customer"
    t.string "connected_account_customer"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "posts"
  add_foreign_key "postslikes", "posts"
  add_foreign_key "replies", "comments"
  add_foreign_key "tagpeople", "posts"
end
