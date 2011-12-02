require "rubygems"
require "bundler/setup"
require "representer"
require "./benchmarks/shared/benchmarker"
require "./benchmarks/shared/database"
require "./benchmarks/shared/models"
require "./test/support/seeds"
require "fileutils"
require 'perftools'

class User
  def first_name
    self.name.split(' ').first
  end
end

class UserRepresenter < Representer::Base
  namespace  "user"
  attributes "id", "name", "email"
  methods    "first_name"

end

class MessageRepresenter < Representer::Base
  attributes "id", "body", "user_id"
  fields     "user"

  aggregate "users", "user_id" do |aggregated_ids, representer|
    scope = User.where(:id => aggregated_ids)
    UserRepresenter.new(scope).prepare.group_by { |u| u['user']['id'] }
  end

  def user(hash)
    if found = @aggregated['users'].fetch(hash.delete('user_id'))
      found.first['user']
    end
  end

end


users    = User.where({})
messages = Message.where({})

FileUtils.mkdir_p('profiles/results')

PerfTools::CpuProfiler.start("profiles/results/simple") do
  1000.times { users.represent(:json) }
end

PerfTools::CpuProfiler.start("profiles/results/complex") do
  1000.times { messages.represent(:json) }
end

# RubyProf.start
# 1000.times { users.represent(:json) }
# result = RubyProf.stop
# printer = RubyProf::GraphPrinter.new(result)
# printer.print(STDOUT)
# printer.print(File.open("profiles/results/simple-graph.html", "w"))

# printer = RubyProf::CallStackPrinter.new(result)
# printer.print(File.open("profiles/results/simple-callstack.html", "w"))
