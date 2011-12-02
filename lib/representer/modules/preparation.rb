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
        prepared = after_prepare(prepared)
        prepared.each { |item| second_pass(item) } unless skip_second_pass?
        prepared = after_second_pass(prepared)
        @returns_many ? prepared : prepared[0]
      end

      def after_prepare(prepared)
        prepared
      end
      alias :after_first_pass :after_prepare

      def after_second_pass(prepared)
        prepared
      end

    end
  end
end
