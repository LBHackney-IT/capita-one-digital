require "bundler/setup"
require "capita/one_digital"
require "savon/mock/spec_helper"
require "webmock/rspec"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Savon::SpecHelper

  helpers = Module.new do
    def file_fixture_path(name)
      File.expand_path("../fixtures/#{name}", __FILE__)
    end

    def file_fixture(name)
      File.read(file_fixture_path(name))
    end

    def response_fixture(name)
      file_fixture("responses/#{name}")
    end

    def wsdl_fixture(name)
      file_fixture("wsdls/#{name}")
    end
  end

  config.include helpers

  config.before do
    stub_request(:get, %r{^https://example.com/ws/(.+)\.wsdl$}).to_return do |request|
      { status: 200, headers: { "Content-Type" => "text/xml;charset=UTF-8" }, body: wsdl_fixture(request.uri.basename) }
    end
  end
end
