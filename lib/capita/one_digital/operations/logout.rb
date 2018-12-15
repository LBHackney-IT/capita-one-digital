require "capita/one_digital/operations/base"

module Capita
  module OneDigital
    module Operations
      class Logout < Base
        self.endpoint = "citizenportallogout"
        self.operation = :citizen_portal_log_out

        def call(token)
          response = request(token: token)

          if response.success?
            true
          else
            raise_api_error("Unable to logout", response)
          end
        end
      end
    end
  end
end
