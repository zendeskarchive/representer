module Representer
  module Modules
    module Configuration

      # Writers

      def attributes(*args)
        @representable_attributes = (['id'] + args).uniq
      end

      def methods(*args)
        @representable_methods    = args
      end

      def fields(*args)
        @representable_fields     = args
      end

      def namespace(name, plural = nil)
        @representable_namespace         = name
        @representable_namespace_plural  = plural ? plural : name + "s"
      end

      # Readers

      def representable_attributes
        @representable_attributes ||= ['id']
      end

      def representable_methods
        @representable_methods ||= []
      end

      def representable_fields
        @representable_fields ||= []
      end

      def representable_namespace
        @representable_namespace
      end

      def representable_namespace_plural
        @representable_namespace_plural
      end

    end
  end
end
