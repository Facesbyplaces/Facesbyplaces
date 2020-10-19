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

ActiveRecord::Schema.define(version: 2020_10_19_034510) do

  create_table "memorial_user_relationships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "memorial_id", null: false
    t.string "relationship"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["memorial_id"], name: "index_memorial_user_relationships_on_memorial_id"
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
  end

  add_foreign_key "memorial_user_relationships", "memorials"
end
