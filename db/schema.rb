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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110117215607) do

  create_table "bank_accounts", :force => true do |t|
    t.string   "account_number"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"

  create_table "creditors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expenses", :force => true do |t|
    t.date     "transaction_date"
    t.decimal  "opening_balance",    :precision => 8, :scale => 2
    t.decimal  "ending_balance",     :precision => 8, :scale => 2
    t.decimal  "transaction_amount", :precision => 8, :scale => 2
    t.string   "description"
    t.integer  "upload_detail_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "balance",            :precision => 8, :scale => 2
    t.integer  "bank_account_id"
    t.integer  "creditor_id"
    t.integer  "category_id"
  end

  add_index "expenses", ["bank_account_id"], :name => "index_expenses_on_bank_account_id"
  add_index "expenses", ["category_id"], :name => "index_expenses_on_category_id"
  add_index "expenses", ["creditor_id"], :name => "index_expenses_on_creditor_id"
  add_index "expenses", ["upload_detail_id"], :name => "index_expenses_on_upload_detail_id"

  create_table "presets", :force => true do |t|
    t.string   "keyphrase"
    t.integer  "creditor_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "presets", ["category_id"], :name => "index_presets_on_category_id"
  add_index "presets", ["creditor_id"], :name => "index_presets_on_creditor_id"

  create_table "upload_details", :force => true do |t|
    t.string   "bankaccount"
    t.string   "currency"
    t.date     "transaction_date"
    t.decimal  "opening_balance",    :precision => 8, :scale => 2
    t.decimal  "ending_balance",     :precision => 8, :scale => 2
    t.date     "interest_date"
    t.decimal  "transaction_amount", :precision => 8, :scale => 2
    t.string   "description"
    t.integer  "upload_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "upload_details", ["upload_id"], :name => "index_upload_details_on_upload_id"

  create_table "uploads", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tab_file_name"
    t.string   "tab_content_type"
    t.integer  "tab_file_size"
    t.datetime "tab_updated_at"
  end

end
