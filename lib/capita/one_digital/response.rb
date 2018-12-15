module Capita
  module OneDigital
    class Response
      OK = "OK".freeze
      INVALID = "INVALID".freeze

      attr_reader :operation, :response, :body

      def initialize(operation, response)
        @operation, @response = operation, response
        @body = response.body[:"#{operation}_response"]
      end

      def [](key)
        body[key]
      end

      def result
        body[:result]
      end

      def code
        result[:result_code]
      end

      def message
        result[:result_message]
      end

      def success?
        code == OK
      end
    end
  end
end
