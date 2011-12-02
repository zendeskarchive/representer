require "active_record"
require "logger"

ActiveRecord::Base.establish_connection({ "adapter" => "sqlite3", "database" => ":memory:" })

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger       = Logger.new(nil)

ActiveRecord::Schema.define(:version => 1) do

  drop_table "messages" rescue nil
  create_table "messages" do |t|
    t.text     "body"
    t.integer  "user_id"
    t.string   "internal_secret_token"
  end
  add_index :messages, :user_id

  drop_table "attachments" rescue nil
  create_table "attachments" do |t|
    t.string   "filename"
    t.integer  "message_id"
  end
  add_index :attachments, :message_id

  drop_table "users" rescue nil
  create_table "users" do |t|
    t.string   "name"
    t.string   "email"
    t.string   "internal_secret_token"
  end

end

