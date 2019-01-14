require "savon"

module Capita
  module OneDigital
    module Operations
      class Base
        NAMESPACED_KEYS = %i[
          title forename middlename surname
          address1 address2 address3 address4 address5 postcode uprn
        ]

        class << self
          attr_accessor :operation, :endpoint

          def client
            clients[operation] ||= Savon.client(client_options(OneDigital.config))
          end

          def [](*args)
            new(client).call(*args)
          end

          private
            def clients
              Thread.current[:__capita_one_digial_clients__] ||= {}
            end

            def config
              OneDigital.config
            end

            def client_options(config)
              {
                wsdl: wsdl_url(config),
                endpoint: endpoint_url(config),
                proxy: config.proxy,
                wsse_timestamp: true,
                wsse_auth: wsse_auth(config),
                logger: config.logger,
                log_level: config.log_level,
                log: config.log,
                element_form_default: :qualified
              }
            end

            def wsdl_url(config)
              "#{config.endpoint}/#{endpoint}.wsdl"
            end

            def endpoint_url(config)
              "#{config.endpoint}/#{endpoint}"
            end

            def wsse_auth(config)
              [config.username, config.password, :digest]
            end
        end

        def initialize(client)
          @client = client
        end

        private

          def client
            @client
          end

          def operation
            self.class.operation
          end

          def request(message)
            Response.new(operation, client.call(operation, message: namespace_keys(message)))
          rescue Savon::Error => e
            raise ApiError, "#{e.class}: #{e.message}"
          end

          def raise_api_error(message, response)
            raise ApiError, "#{message} - code: #{response.code}; message: #{response.message}"
          end

          def namespace_keys(hash)
            return hash if hash.is_a?(String)

            hash.each_with_object({}) do |(key, value), namespaced_hash|
              tag = Gyoku.xml_tag(key)
              namespace = NAMESPACED_KEYS.include?(key) ? "ins0" : "tns"
              namespaced_tag = "#{namespace}:#{tag}"

              if value.is_a?(Hash)
                namespaced_hash[namespaced_tag] = namespace_keys(value)
              else
                namespaced_hash[namespaced_tag] = value
              end
            end
          end
      end
    end
  end
end
