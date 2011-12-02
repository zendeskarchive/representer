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

# to_json config
to_json_options = {
  :only => ["id", "body", "user_id"],
  :methods => ["user", "attachments"]
}

benchmarker = Benchmarker.new(50)

report = benchmarker.run("simple represent") do
  scope = Message.where({}).limit(50)
  scope.represent(:json)
end

puts report

report = benchmarker.run("simple to_json") do
  scope = Message.where({}).limit(50)
  scope.to_json(to_json_options)
end

puts report

report = benchmarker.run("simple to_json with preload_associations") do
  scope = Message.where({}).limit(50)
  Message.send(:preload_associations, scope, [:user, :attachments] )
  scope.to_json(to_json_options)
end

puts report
