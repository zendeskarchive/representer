module Representer
  module Modules
    module Associations

      ##
      # has_many macro installs the field, aggregate and the method
      #
      def has_many(name, options = {})
        fields name
        name        = name.to_s
        klass_name  = options[:klass_name]  || name.singularize.capitalize
        klass       = klass_name.constantize
        pr_key_name = self.name.sub('Representer', '').downcase
        primary_key = options[:foreign_key] || 'id'
        foreign_key = options[:primary_key] || "#{pr_key_name}_id"
        foreign_rep = options[:representer] ||
                      "#{klass_name}Representer".constantize
        namespace   = foreign_rep.representable_namespace
        aggregate name, primary_key do |ids, representer|
          scope = klass.where(foreign_key => ids)
          foreign_rep.new(scope).prepare.group_by do |record|
            namespace ? record[namespace][foreign_key] : record[foreign_key]
          end
        end
        class_eval <<-STR
          def #{name}(record)
            aggregated_#{name}[record.#{primary_key}] || []
          end
        STR

      end

      ##
      # belongs_to macro installs the field, aggregate and the method
      #
      def belongs_to(name, options = {})
        fields name
        name        = name.to_s
        klass_name  = options[:klass_name]  || name.singularize.capitalize
        klass       = klass_name.constantize
        pr_key_name = name.downcase.singularize
        primary_key = options[:foreign_key] || 'id'
        foreign_key = options[:primary_key] || "#{pr_key_name}_id"
        foreign_rep = options[:representer] ||
                      "#{klass_name}Representer".constantize
        namespace   = foreign_rep.representable_namespace
        aggregate name, foreign_key do |ids, representer|
          scope = klass.where(primary_key => ids)
          foreign_rep.new(scope).prepare.group_by do |record|
            namespace ? record[namespace][primary_key] : record[primary_key]
          end.inject({}) do |memo, item|
            id, serialized = item
            memo[id] = namespace ? serialized.first[namespace] : serialized.first
            memo
          end
        end
        class_eval <<-STR
          def #{name}(record)
            aggregated_#{name}[record.#{foreign_key}] || []
          end
        STR

      end

    end
  end
end
