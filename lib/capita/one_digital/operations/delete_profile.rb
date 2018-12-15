require "capita/one_digital/operations/base"

module Capita
  module OneDigital
    module Operations
      class DeleteProfile < Base
        self.endpoint = "citizenportaldeleteprofile"
        self.operation = :citizen_portal_delete_profile

        def call(username)
          response = request(username: username)

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
