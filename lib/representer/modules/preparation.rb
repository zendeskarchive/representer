module Representer
  module Modules
    module Preparation

      def before_prepare
      end

      def collection?
        @representable.is_a?(Array) or @representable.is_a?(ActiveRecord::Relation)
      end

      # Should we skip the second pass?
      def skip_second_pass?
        self.class.representable_fields.size == 0
      end

      def prepare
        before_prepare
        prepared = @representable.collect { |item| first_pass(item) }
        prepared = after_first_pass(prepared)
        prepared = after_prepare(prepared)
        @returns_many ? prepared : prepared[0]
      end

      def after_first_pass(prepared)
        prepared
      end

      def after_prepare(prepared)
        # Do not perform a second pass when there is no need
        return prepared if skip_second_pass?

        # Run second_pass on each prepared item
        # Second pass will modify the item, so we don't need to capture the output
        prepared.each { |item| second_pass(item) }

        prepared
      end

    end
  end
end
