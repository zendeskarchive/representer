require "rubygems"
require "bundler/setup"
require "representer"
require "./benchmarks/shared/benchmarker"
require "./benchmarks/shared/database"
require "./benchmarks/shared/models"
require "./benchmarks/relations/representers"

1000.times {
  user = User.create(:name => "some user")
  message = user.messages.create(:body => "some message")
  message.attachments.create(:filename => "foo.jpg")
}

require "active_model_serializers"

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
end

class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :message_id, :filename
end

class MessageSerializer < ActiveModel::Serializer
  attributes :id, :body
  has_many :attachments
  has_one :user
end

def get_scope
  Message.where({}).includes(:user, :attachments).limit(50)
end

# to_json config
to_json_options = {
  :methods => ["user", "attachments"],
  :only => ["id", "body", "user_id"]
}
benchmarker = Benchmarker.new(50)

report = benchmarker.run("simple to_json") do
  scope = get_scope
  scope.to_json(to_json_options)
end

scope = get_scope

puts report
puts ""
report = benchmarker.run("active model serializer") do
  ActiveModel::ArraySerializer.new(get_scope).to_json
end

puts report
puts ""
report = benchmarker.run("simple represent") do
  scope = Message.where({}).limit(50)
  MessageRepresenter.new(scope).render(:json)
end

puts report
puts ""