module Representer
  module Modules
    module Rendering

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
end
