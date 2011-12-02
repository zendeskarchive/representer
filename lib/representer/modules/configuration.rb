module Representer
  module Modules
    module Configuration

      # Writers

      def attributes(*args)
        @representable_attributes = (['id'] + args).uniq
      end

      def methods(*args)
        hash = args.last.is_a?(Hash) ? args.pop : nil
        @representable_methods = args
        hash.each { |method, key| @representable_methods.push [key, method] } if hash
      end

      def fields(*args)
        hash = args.last.is_a?(Hash) ? args.pop : nil
        @representable_fields = args
        hash.each { |method, key| @representable_fields.push [key, method] } if hash
      end

      def namespace(name, plural = nil)
        @representable_namespace         = name
        @representable_namespace_plural  = plural ? plural : name + "s"
      end

      def aggregate(name, key = 'id', &block)
        aggregation_keys.push key unless key == 'id' or aggregation_keys.include?(key)
        @aggregation_blocks ||= {}
        @aggregation_blocks[key] ||= []
        @aggregation_blocks[key].push({ :name => name, :block => block })
        class_eval <<-STR
          def aggregated_#{name}
            @aggregated['#{name}']
          end
        STR
      end

      def aggregation_keys
        @aggregation_keys ||= []
      end

      def aggregation_blocks
        @aggregation_blocks ||= {}
      end

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
