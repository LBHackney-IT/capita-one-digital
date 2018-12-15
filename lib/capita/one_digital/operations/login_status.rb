require "capita/one_digital/operations/base"

module Capita
  module OneDigital
    module Operations
      class LoginStatus < Base
        self.endpoint = "citizenportalloginstatus"
        self.operation = :citizen_portal_log_in_status

        def call(token)
          response = request(token: token)

          if response.success?
            true
          else
            false
          end
        end
      end
    end
  end
end
