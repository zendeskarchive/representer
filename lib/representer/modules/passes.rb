require 'set'

module Representer
  module Modules
    module Passes

      def extract_attributes(record)
        # Make the representable_attributes take precedence before the attributes
        # This allows us to skip the costly ActiveRecord#attributes
        attribute_names = representable_attributes || record.attributes.keys

        # Resulting hash
        attribute_names.inject({}) do |hash, name|
          hash[name] = record.read_attribute(name)
          hash
        end
      end

      def aggregate_keys(hash)
        @aggregates['id'].push hash['id']
        self.class.aggregation_keys.each do |key|
          @aggregates[key] ||= []
          @aggregates[key].push hash[key]
        end
      end

      def load_aggregates
        @aggregates.each_pair do |key, aggregated_keys|
          blocks = self.class.aggregation_blocks[key]
          next unless blocks
          blocks.each do |entry|
            @aggregated[entry[:name]] = entry[:block].call(aggregated_keys, self)
          end
        end
      end

      def first_pass(record)
        hash = extract_attributes(record)

        aggregate_keys hash

        representable_methods.each do |method|
          if method.is_a?(Array)
            field, method = method
          else
            field, method = method, method
          end
          hash[field] = record.send(method)
        end

        if self.class.representable_namespace
          { self.class.representable_namespace => hash }
        else
          hash
        end
      end

      def second_pass(prepared_hash)
        scoped_hash = if self.class.representable_namespace
          prepared_hash[self.class.representable_namespace]
        else
          prepared_hash
        end
        representable_fields.each do |field|
          if field.is_a?(Array)
            field, method = field
          else
            field, method = field, field
          end
          scoped_hash[field] = self.send(method, scoped_hash)
        end
        scoped_hash
      end

      private
      [
        :representable_fields,
        :representable_methods,
        :representable_attributes
      ].each do |method|
        define_method method do
          if picked.empty?
            self.class.send(method)
          else
            select_picked(self.class.send(method))
          end
        end
      end

      def select_picked(definitions)
        definitions.select do |field|
          if field.kind_of?(Array)
            picked.include?(field.first.to_s)
          else
            picked.include?(field.to_s)
          end
        end
      end

      def picked
        return @picked if @picked

        @picked = Set.new(
          (@options[:pick] || @options["pick"] || []).map(&:to_s)
        )
      end
    end
  end
end
