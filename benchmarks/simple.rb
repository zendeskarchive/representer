require "rubygems"
require "bundler/setup"
require "representer"
require "./benchmarks/shared/benchmarker"
require "./benchmarks/shared/database"
require "./benchmarks/shared/models"

50.times { User.create(:name => "some user") }

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

benchmarker = Benchmarker.new(50)
scope       = User.where({})

report = benchmarker.run("simple represent") do
  scope.represent(:json)
end

puts report

report = benchmarker.run("simple to_json") do
  scope.to_json(:only => [:id, :name, :email])
end

puts report
