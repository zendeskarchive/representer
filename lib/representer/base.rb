require "yajl"
require "representer/modules/rendering"
require "representer/modules/preparation"
require "representer/modules/passes"
require "representer/modules/configuration"

module Representer

  class Base

    extend  Representer::Modules::Configuration
    include Representer::Modules::Rendering
    include Representer::Modules::Preparation
    include Representer::Modules::Passes

    attr_accessor :scope

    def initialize(representable, options = {})
      @representable = representable.is_a?(ActiveRecord::Relation) ? representable.all : representable
      @scope         = options[:scope]
      @options       = options
      @ids           = []
    end

    # "Legacy" aliases
    alias :process_single_record :first_pass
    alias :apply_fields :second_pass

  end

end
