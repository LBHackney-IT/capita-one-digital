require "capita/one_digital/operations/base"

module Capita
  module OneDigital
    module Operations
      class Profile < Base
        self.endpoint = "citizenportalprofile"
        self.operation = :citizen_portal_profile

        def call(username)
          response = request(username: username)

          if response.success?
            response[:citizen_portal_profile_details]
          else
            false
          end
        end
      end
    end
  end
end
