require "active_record"
require "logger"

module DatabaseConnections
  class << self
    attr_accessor :sqlite3
    attr_accessor :mysql
  end
end

loaded = if File.exists?('test/database.yml')
  YAML::load(File.open('test/database.yml'))
else
  puts "test/database.yml NOT found, falling back to sample"
  YAML::load(File.open('test/database.yml.sample'))
end
DatabaseConnections.mysql   = loaded
DatabaseConnections.sqlite3 = { "adapter" => "sqlite3", "database" => ":memory:" }

ActiveRecord::Base.establish_connection DatabaseConnections.sqlite3

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger       = Logger.new(nil)

ActiveRecord::Schema.define(:version => 1) do

  drop_table "messages" rescue nil
  create_table "messages" do |t|
    t.text     "body"
    t.integer  "user_id"
    t.string   "internal_secret_token"
  end

  drop_table "attachments" rescue nil
  create_table "attachments" do |t|
    t.string   "filename"
    t.integer  "message_id"
  end

  drop_table "users" rescue nil
  create_table "users" do |t|
    t.string   "name"
    t.string   "email"
    t.string   "internal_secret_token"
  end

end

class Message < ActiveRecord::Base
  belongs_to :user
  has_many   :attachments
end

class Attachment < ActiveRecord::Base
  belongs_to :message
end

class User < ActiveRecord::Base
  has_many :messages
end

class MysqlUser < ActiveRecord::Base
  set_table_name "users"
end

MysqlUser.establish_connection DatabaseConnections.mysql
MysqlUser.delete_all