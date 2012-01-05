module Representer

  # Representer::Simple is an representer which allows work on ActiveRecord::Base instances,
  # also during the second pass
  #
  # It is currently in an experimental phase
  class Simple < Base

    def run_second_pass(prepared)
      prepared.each { |record, hash| second_pass(record, hash) } unless skip_second_pass?
    end

    def finalize(prepared)
      prepared = prepared.collect { |record, hash| hash }
      @returns_many ? prepared : prepared[0]
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
        scoped_hash[field] = self.send(method, record, scoped_hash)
      end
      scoped_hash
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

    def aggregate_keys(record, hash)
      @aggregates['id'].push record.id
      self.class.aggregation_keys.each do |key|
        @aggregates[key] ||= []
        @aggregates[key].push record.send(key)
      end
    end

  end

end

