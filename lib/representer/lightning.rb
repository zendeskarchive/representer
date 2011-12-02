module Representer

  class Lightning < Base

    attr_accessor :lightning_mode

    def before_prepare
      if @representable.is_a?(ActiveRecord::Relation) and
         self.class.representable_methods.size == 0 and
         self.class.representable_fields.size == 0
        @representable  = lightning_mode_convert
        @lightning_mode = true
      end
    end

    def lightning_mode_convert
      client  = @representable.connection.instance_variable_get('@connection')
      result = client.query(@representable.to_sql)
      case result.class.name
        when 'Mysql2::Result'
          result.each(:as => :hash)
        when 'SQLite3::ResultSet'
          tmp = []
          result.each { |r| tmp.push(r)}
          tmp
        else
          result
      end
    end

    def extract_attributes(record)
      return super unless @lightning_mode

      # Make the representable_attributes take precedence before the attributes
      # This allows us to skip the costly ActiveRecord#attributes
      attribute_names = self.class.representable_attributes || record.keys

      # Resulting hash
      attribute_names.inject({}) do |hash, name|
        hash[name] = record[name]
        hash
      end
    end

  end

end

