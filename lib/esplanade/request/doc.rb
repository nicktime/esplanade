module Esplanade
  class Request
    class Doc
      def initialize(main_documentation, raw)
        @main_documentation = main_documentation
        @raw = raw
      end

      def tomogram
        @tomogram ||= @main_documentation.find_request(method: @raw.method, path: @raw.path)
        return @tomogram unless @tomogram.nil?
        raise Esplanade::RequestNotDocumented,
              method: @raw.method,
              path: @raw.path
      rescue NoMethodError
        raise DocRequestError
      end

      def json_schema
        @json_schema ||= tomogram.request
        return @json_schema unless @json_schema == {}
        raise Esplanade::DocRequestWithoutJsonSchema,
              method: method,
              path: path
      rescue NoMethodError
        raise DocRequestError
      end

      def method
        @method ||= tomogram.method
      rescue ArgumentError
        raise DocRequestError
      end

      def path
        @path ||= tomogram.path.to_s
      rescue NoMethodError
        raise DocRequestError
      end

      def responses
        @responses ||= tomogram.responses
      rescue NoMethodError
        raise DocRequestError
      end
    end
  end
end
