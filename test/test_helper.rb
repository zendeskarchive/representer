require "rubygems"
require "bundler/setup"
$:.push File.expand_path("../../lib", __FILE__)

require 'simplecov'
SimpleCov.start do
  add_filter 'test/'
end

gem 'minitest'
require 'minitest/unit'
MiniTest::Unit.autorun
require 'mocha'
require "mysql2"
require "active_record"
require 'representer'

module Representer
  module Tests
  end
end

Dir.glob("#{File.dirname(__FILE__)}/support/*.rb").each { |f| require f }
