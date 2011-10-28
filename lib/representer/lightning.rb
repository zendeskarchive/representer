module Representer

  class Lightning < Base

    def before_prepare
      if @representable.is_a?(ActiveRecord::Relation) and
         self.class.representable_fields.size == 0 and
         self.class.representable_methods.size == 0
        @representable  = lightning_mode_convert
        @lightning_mode = true
      end
    end

    def lightning_mode_convert
      client  = @representable.connection.instance_variable_get('@connection')
      results = client.query(@representable.to_sql)
      headers = results.fields
      results.collect do |row|
        result = {}
        headers.each_with_index do |header, index|
          result[header] = row[index]
        end
        result
      end
    end

    def process_single_record(record)
      if @lightning_mode
        # Extract the id into an aggregate array
        @ids.push record['id']
        # Cache the attributes into a local variable
        attributes = record
      else
        # Extract the id into an aggregate array
        @ids.push record.id
        # Cache the attributes into a local variable
        attributes = record.attributes
      end
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

  end

end

