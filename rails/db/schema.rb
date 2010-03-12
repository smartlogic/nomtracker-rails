# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090827134927) do

  create_table "emails", :force => true do |t|
    t.string  "address"
    t.integer "user_id"
    t.string  "email_state",     :limit => 30
    t.string  "activation_code", :limit => 40
  end

  add_index "emails", ["address"], :name => "index_emails_on_address", :unique => true
  add_index "emails", ["user_id"], :name => "index_emails_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "transactions", :force => true do |t|
    t.integer  "creditor_id"
    t.integer  "debtor_id"
    t.decimal  "amount",             :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "when"
    t.string   "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.string   "image_updated_at"
  end

  add_index "transactions", ["creditor_id"], :name => "index_transactions_on_creditor_id"
  add_index "transactions", ["debtor_id"], :name => "index_transactions_on_debtor_id"

  create_table "users", :force => true do |t|
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "user_state",                :limit => 30
    t.boolean  "wants_to_be_notified",                     :default => true, :null => false
  end

  create_view "normalized_transactions", "CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY INVOKER VIEW `normalized_transactions` AS (select `transactions`.`id` AS `id`,`transactions`.`creditor_id` AS `me`,`transactions`.`debtor_id` AS `you`,`transactions`.`amount` AS `amount`,`transactions`.`created_at` AS `created_at`,`transactions`.`updated_at` AS `updated_at`,`transactions`.`when` AS `when`,`transactions`.`description` AS `description` from `transactions`) union (select `transactions`.`id` AS `id`,`transactions`.`debtor_id` AS `me`,`transactions`.`creditor_id` AS `you`,(`transactions`.`amount` * -(1)) AS `amount`,`transactions`.`created_at` AS `created_at`,`transactions`.`updated_at` AS `updated_at`,`transactions`.`when` AS `when`,`transactions`.`description` AS `description` from `transactions`)", :force => true do |v|
    v.column :id
    v.column :me
    v.column :you
    v.column :amount
    v.column :created_at
    v.column :updated_at
    v.column :when
    v.column :description
  end

end
