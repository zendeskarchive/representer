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

class LightningUserRepresenter < Representer::Lightning
  namespace  "user"
  attributes "id", "name", "email"
end

class UserRepresenter < Representer::Base
  namespace  "user"
  attributes "id", "name", "email"
end

class SimpleUserRepresenter < Representer::Simple
  namespace  "user"
  attributes "id", "name", "email"
end

benchmarker        = Benchmarker.new(50)

report = benchmarker.run("lightning represent") do
  scope              = User.where({})
  base_representer   = LightningUserRepresenter.new(scope)
  base_representer.render(:json)
end

puts report

report = benchmarker.run("base represent") do
  scope              = User.where({})
  base_representer   = UserRepresenter.new(scope)
  base_representer.render(:json)
end

puts report

report = benchmarker.run("simple represent") do
  scope              = User.where({})
  simple_representer = SimpleUserRepresenter.new(scope)
  simple_representer.render(:json)
end

puts report
