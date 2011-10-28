require "yajl"

module Representer

  class Base

    attr_accessor :scope

    class << self
      attr_accessor :representable_attributes
      attr_accessor :representable_methods
      attr_accessor :representable_fields
      attr_accessor :representable_namespace
      attr_accessor :representable_namespace_plural

      def attributes(*args)
        self.representable_attributes = ['id'] + args
      end

      def methods(*args)
        self.representable_methods    = args
      end

      def fields(*args)
        self.representable_fields     = args
      end

      def namespace(name, plural = nil)
        self.representable_namespace         = name
        self.representable_namespace_plural  = plural ? plural : name + "s"
      end

      def representable_attributes
        @representable_attributes ||= ['id']
      end

      def representable_methods
        @representable_methods ||= []
      end

      def representable_fields
        @representable_fields ||= []
      end

    end

    def initialize(representable, options = {})
      @representable = representable.is_a?(ActiveRecord::Relation) ? representable.all : representable
      @scope         = options[:scope]
      @options       = options
      @ids           = []
    end

    def before_prepare
    end

    def prepare
      before_prepare
      prepared = if @representable.is_a?(Array)
        @representable.collect do |item|
          process_single_record(item)
        end
      else
        process_single_record(@representable)
      end
      after_prepare(prepared)
    end

    # Should we skip the second pass?
    def skip_second_pass?
      self.class.representable_fields.size == 0
    end

    def after_prepare(prepared)
      # Do not perform a second pass when there is no need
      return prepared if skip_second_pass?

      if prepared.is_a?(Array)
        prepared.collect do |item| apply_fields(item); item end
      else
        apply_fields(prepared)
        prepared
      end
    end

    def apply_fields(prepared_hash)
      scoped_hash = if self.class.representable_namespace
        prepared_hash[self.class.representable_namespace]
      else
        prepared_hash
      end
      self.class.representable_fields.each do |field|
        if value = self.send(field, scoped_hash)
          scoped_hash[field] = value
        end
      end
      scoped_hash
    end

    def process_single_record(record)
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
        hash[method] = record.send(method)
      end

      if self.class.representable_namespace
        { self.class.representable_namespace => hash }
      else
        hash
      end
    end

    def render(method = :json)
      if method == :xml
        render_xml
      else
        Yajl::Encoder.encode(prepare)
      end
    end

    def render_xml
      prepared = prepare
      if prepared.is_a?(Hash)
        if self.class.representable_namespace
          prepared = prepared[self.class.representable_namespace]
          prepared.to_xml(:root => self.class.representable_namespace)
        else
          prepare.to_xml
        end
      elsif prepared.is_a?(Array)
        if self.class.representable_namespace
          prepared = prepared.collect { |item| item[self.class.representable_namespace] }
          prepared.to_xml(:root => self.class.representable_namespace_plural)
        else
          prepared.to_xml
        end
      end
    end

  end

end

