require "capita/one_digital/operations/base"

module Capita
  module OneDigital
    module Operations
      class EditProfile < Base
        self.endpoint = "citizenportaleditprofile"
        self.operation = :citizen_portal_edit_profile

        def call(username, profile)
          details = { username: username }.merge(profile)
          response = request(citizen_portal_edit_profile_details: details)

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
