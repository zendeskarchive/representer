require 'representer/base'
require 'representer/simple'
require 'representer/lightning'
require 'representer/extensions'

module Representer

  class << self
    attr_accessor :lookup_table
  end

  self.lookup_table = {}

  def self.lookup_constant(name, parent = Object)
    parent.const_get(name)
  end

  def self.lookup(name)
    if found = lookup_table[name]
      found
    else
      camel  = "#{name.camelcase}Representer"
      scopes = camel.split("::")
      found  = lookup_constant(scopes.shift)
      scopes.each do |scope|
        found = lookup_constant(scope, found)
      end
      lookup_table[name] = found
      found
    end
  end

end
