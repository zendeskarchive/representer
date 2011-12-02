require 'representer/base'
require 'representer/lightning'
require 'representer/extensions'

module Representer

  class << self
    attr_accessor :lookup_table
  end

  self.lookup_table = {}

  def self.lookup(name)
    if found = lookup_table[name]
      found
    else
      name = "#{name.camelcase}Representer"
      scopes = name.split("::")
      found = Object.const_get(scopes.shift)
      scopes.each do |scope|
        found = found.const_get(scope)
      end
      lookup_table[name] = found
      found
    end
  end
end
