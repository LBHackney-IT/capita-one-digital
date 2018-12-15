require "capita/one_digital/operations/base"

module Capita
  module OneDigital
    module Operations
      class Login < Base
        self.endpoint = "citizenportalthirdpartylogin"
        self.operation = :citizen_portal_third_party_log_in

        def call(username)
          response = request(username: username)

          if response.success?
            response[:token]
          else
            raise_api_error("Unable to login", response)
          end
        end
      end
    end
  end
end
