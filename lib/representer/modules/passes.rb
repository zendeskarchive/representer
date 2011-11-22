module Representer
  module Modules
    module Passes

      def first_pass(record)
        # Extract the id into an aggregate array
        @ids.push record.id
        # Cache the attributes into a local variable
        attributes = record.attributes
        # Resulting hash
        hash = {}
        # Copy the attributes
        self.class.representable_attributes.each do |attribute|
          hash[attribute] = attributes[attribute]
        end

        self.class.representable_methods.each do |method|
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
        self.class.representable_fields.each do |field|
          if field.is_a?(Array)
            field, method = field
          else
            field, method = field, field
          end
          scoped_hash[field] = self.send(method, scoped_hash)
        end
        scoped_hash
      end

    end
  end
end
