module Representer

  ##
  # Representer::Simple is an representer which allows work on
  # ActiveRecord::Base instances, also during the second pass
  #
  # Instead of passing the hash to field methods, it passes
  # the ActiveRecord::Base instance
  #
  class Simple < Base

    def run_second_pass(prepared)
      prepared.each do |record, hash|
        second_pass(record, hash)
      end unless skip_second_pass?
    end

    def finalize(prepared)
      prepared = prepared.collect { |record, hash| hash }
      super
    end

    def first_pass(record)
      hash = extract_attributes(record)

      aggregate_keys record, hash

      self.class.representable_methods.each do |method|
        if method.is_a?(Array)
          field, method = method
        else
          field, method = method, method
        end
        hash[field] = record.send(method)
      end

      if self.class.representable_namespace
        hash = { self.class.representable_namespace => hash }
      end
      [record, hash]
    end

    def second_pass(record, prepared_hash)
      load_aggregates
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
        scoped_hash[field] = self.send(method, record)
      end
      scoped_hash
    end

    ##
    # Extract all keys that were specified using #aggregate
    #
    # We override Representer::Base to call the method directly instead of []
    #
    def aggregate_keys(record, hash)
      @aggregates['id'].push record.id
      self.class.aggregation_keys.each do |key|
        @aggregates[key] ||= []
        @aggregates[key].push record.send(key)
      end
    end

  end

end

