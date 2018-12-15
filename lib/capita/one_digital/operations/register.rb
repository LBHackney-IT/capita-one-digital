require "capita/one_digital/operations/base"

module Capita
  module OneDigital
    module Operations
      class Register < Base
        self.endpoint = "citizenportalregister"
        self.operation = :citizen_portal_register

        def call(username, profile)
          response = request({ username: username }.merge(profile))

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
