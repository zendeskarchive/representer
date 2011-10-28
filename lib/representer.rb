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
      found = Object.const_get("#{name.camelcase}Representer")
      lookup_table[name] = found
      found
    end
  end

end
