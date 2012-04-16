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

# require "active_model_serializers"

# class MessageSerializer < ActiveModel::Serializer
#   attributes :id, :body, :user_id
#   has_many :attachments
#   has_one :user
# end

# require 'roar/representer/json'
# require 'roar/representer/feature/hypermedia'

def get_scope
  Message.where({}).limit(50)
end

# module MessageRepresenterRoar
#   include Roar::Representer::JSON
#   include Roar::Representer::Feature::Hypermedia

#   property :title
#   property :id

# end

# to_json config
to_json_options = {
  :only => ["id", "body", "user_id"],
  :methods => ["user", "attachments"]
}
benchmarker = Benchmarker.new(1)


report = benchmarker.run("simple to_json") do
  scope = Message.where({}).limit(50)
  scope.to_json(to_json_options)
end

puts report

# report = benchmarker.run("active model serializer") do
#   ActiveModel::ArraySerializer.new(get_scope).to_json
# end

# puts report

report = benchmarker.run("simple represent") do
  scope = Message.where({}).limit(50)
  MessageRepresenter.new(scope).render(:json)
  # scope.represent(:json)
end

puts report
