require "capita/one_digital/configuration"
require "capita/one_digital/operations"
require "capita/one_digital/response"
require "capita/one_digital/version"

module Capita
  module OneDigital
    class Error < StandardError; end
    class ConfigurationError < Error; end
    class ApiError < Error; end

    class << self
      def delete_profile(username)
        Operations::DeleteProfile[username]
      end

      def edit_profile(username, profile)
        Operations::EditProfile[username, profile]
      end

      def history_service(filter)
        Operations::HistoryService[filter]
      end

      def login(username)
        Operations::Login[username]
      end

      def login_status(token)
        Operations::LoginStatus[token]
      end

      def logout(token)
        Operations::Logout[token]
      end

      def profile(username)
        Operations::Profile[username]
      end

      def register(username, profile)
        Operations::Register[username, profile]
      end

      def session(username)
        Session.new(username, self)
      end

      def exists?(username)
        Operations::Profile[username] ? true : false
      end
    end
  end
end
