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

    attr_accessor :scope, :aggregates

    def initialize(representable, options = {})
      @representable = representable
      @returns_many  = collection?
      @representable = [@representable] unless @returns_many
      @scope         = options[:scope]
      @options       = options
      @aggregates    = { "id" => [] }
      @aggregated    = {}
    end

    # "Legacy" aliases
    alias :process_single_record :first_pass
    alias :apply_fields :second_pass

  end

end
