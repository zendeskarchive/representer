module Representer
  module Modules
    module Preparation

      def before_prepare
      end

      def prepare
        before_prepare
        prepared = if @representable.is_a?(Array)
          @representable.collect do |item|
            first_pass(item)
          end
        else
          first_pass(@representable)
        end
        after_prepare(prepared)
      end

      def after_prepare(prepared)
        # Do not perform a second pass when there is no need
        return prepared if skip_second_pass?

        if prepared.is_a?(Array)
          prepared.collect do |item| second_pass(item); item end
        else
          second_pass(prepared)
          prepared
        end
      end

      # Should we skip the second pass?
      def skip_second_pass?
        self.class.representable_fields.size == 0
      end

    end
  end
end
