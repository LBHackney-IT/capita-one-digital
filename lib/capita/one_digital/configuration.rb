require "logger"

module Capita
  module OneDigital
    class Configuration
      attr_writer :username, :password
      attr_writer :endpoint, :proxy
      attr_writer :logger, :log_level, :log

      def username
        defined?(@username) ? @username : raise_config_error(:username)
      end

      def password
        defined?(@password) ? @password : raise_config_error(:password)
      end

      def endpoint
        defined?(@endpoint) ? @endpoint : raise_config_error(:username)
      end

      def proxy
        defined?(@proxy) ? @proxy : nil
      end

      def logger
        @logger ||= default_logger
      end

      def log_level
        @log_level ||= :info
      end

      def log
        @log ||= false
      end

      private

        def raise_config_error(name)
          raise ConfigurationError, "Please specify a #{name}"
        end

        def default_logger
          Logger.new(STDOUT).tap do |logger|
            logger.level = Logger.const_get(log_level.upcase)
          end
        end
    end

    class << self
      def configure
        @config = Configuration.new
        yield @config
      end

      def config
        unless defined?(@config)
          raise ConfigurationError, "Please configure the client with your credentials"
        end

        @config
      end

      def reset!
        remove_instance_variable(:@config) if defined?(@config)
      end
    end
  end
end
