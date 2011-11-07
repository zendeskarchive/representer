module Representer

  module Extension

    module InstanceMethods

      def represent(format, options = {})
        representer = if options.has_key?(:representer)
          repr = options.delete(:representer)
          repr.is_a?(String) ? Representer.lookup(repr) : repr
        else
          Representer.lookup(representer_name)
        end
        instance = representer.new(self, options)
        instance.render(format)
      end

      def representer_name
        self.class.name
      end

    end

  end

end

class Array

  include Representer::Extension::InstanceMethods

  def representer_name
    self.first ? self.first.class.name : 'Array'
  end

end

if defined?(ActiveRecord::Base)

  class ActiveRecord::Base
    include Representer::Extension::InstanceMethods
  end

end

if defined?(ActiveRecord::Relation)

  class ActiveRecord::Relation
    include Representer::Extension::InstanceMethods

    def representer_name
      self.klass.name
    end
  end

end
