module Representer
  module Modules
    module Configuration

      # Writers

      def attributes(*args)
        @representable_attributes = (['id'] + args.collect(&:to_s)).uniq
      end

      ##
      # Set the methods that will be called on the extracted objects
      # in the first pass
      # The methods can be passed as:
      #  * symbols
      #  * strings
      #  * arrays - [method_name, resulting_key_name]
      #  * arrays - { method_name => resulting_key_name }
      #
      def methods(*args)
        hash = args.last.is_a?(Hash) ? args.pop : nil
        @representable_methods = args.collect do |meth|
          meth.is_a?(Array) ? meth.collect(&:to_s) : meth.to_s
        end
        hash.each do |method, key|
          @representable_methods.push [key, method]
        end if hash
      end

      def fields(*args)
        hash = args.last.is_a?(Hash) ? args.pop : nil
        @representable_fields = args.collect do |field|
          field.is_a?(Array) ? field.collect(&:to_s) : field.to_s
        end
        hash.each do |method, key|
          @representable_fields.push [key, method]
        end if hash
      end

      def namespace(name, plural = nil)
        name                             = name.to_s
        @representable_namespace         = name
        @representable_namespace_plural  = plural ? plural : name + "s"
      end

      def aggregate(name, key = 'id', &block)
        name, key = name.to_s, key.to_s
        aggregation_keys.push key unless key == 'id' ||
                                         aggregation_keys.include?(key)
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
