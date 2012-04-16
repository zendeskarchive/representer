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
  :only => ["id", "body"],
  :methods => ["user", "attachments"]
}

benchmarker = Benchmarker.new(50)

def get_scope
  Message.where({}).limit(1)
end

report = benchmarker.run("simple represent") do
  get_scope.represent(:json)
end

puts report

report = benchmarker.run("simple to_json") do
  get_scope.to_json(to_json_options)
end

puts report
