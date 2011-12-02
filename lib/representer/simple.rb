module Representer

  # Representer::Simple is an representer which allows work on ActiveRecord::Base instances,
  # also during the second pass
  #
  # It is currently in an experimental phase
  class Simple < Base

    def run_second_pass(prepared)
      prepared.each { |record, hash| second_pass(record, hash) } unless skip_second_pass?
    end

    def first_pass(record)
      hash = super
      [record, hash]
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

  end

end

