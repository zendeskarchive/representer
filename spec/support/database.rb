require "active_record"
require "logger"

ActiveRecord::Base.establish_connection("adapter" => "sqlite3", "database" => ":memory:")

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger       = Logger.new(nil)

ActiveRecord::Schema.define(:version => 1) do

  create_table "messages", do |t|
    t.text     "body"
    t.integer  "user_id"
    t.string   "internal_secret_token"
  end

  create_table "users", do |t|
    t.string   "name"
    t.string   "email"
    t.string   "internal_secret_token"
  end

end

class Message < ActiveRecord::Base
  belongs_to :user
end

class User < ActiveRecord::Base
  has_many :messages
end

peter  = User.create(:name => 'Peter',   :email => "peter@email.com")
olivia = User.create(:name => 'Olivia',  :email => "olivia@email.com")
User.create(:name => 'Walter',  :email => "walter@email.com")
User.create(:name => 'Astrid',  :email => "astrid@email.com")
User.create(:name => 'Broyles', :email => "broyles@email.com")

Message.create(:body => 'Bishop FTW', :user_id => peter.id)
Message.create(:body => 'Dunham', :user_id => olivia.id)
