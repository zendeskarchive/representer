module Representer
  module Modules
    module Passes

      def extract_attributes(record)
        record.attributes
      end

      def first_pass(record)
        # Cache the attributes into a local variable
        attributes = extract_attributes(record)
        # Extract the id into an aggregate array
        self.aggregates["id"].push attributes['id']
        # Resulting hash
        hash = {}
        # Copy the attributes
        self.class.representable_attributes.each do |attribute|
          hash[attribute] = attributes[attribute]
        end

        self.class.representable_methods.each do |method|
          hash[method] = record.send(method)
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
          scoped_hash[field] = self.send(field, scoped_hash)
        end
        scoped_hash
      end

    end
  end
end