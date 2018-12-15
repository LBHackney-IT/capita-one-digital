RSpec.describe Capita::OneDigital do
  before(:all) do
    savon.mock!
  end

  it "has a version number" do
    expect(Capita::OneDigital::VERSION).not_to be nil
  end

  describe "configuration" do
    describe ".configure" do
      let(:configuration) { Capita::OneDigital::Configuration }

      it "yields a config instance" do
        expect { |b| described_class.configure(&b) }.to yield_with_args(configuration)
      end
    end

    describe ".config" do
      context "when not configured" do
        before do
          described_class.reset!
        end

        it "raises an error" do
          expect {
            described_class.config
          }.to raise_error(Capita::OneDigital::ConfigurationError)
        end
      end

      context "when configured" do
        before do
          described_class.configure do |config|
            config.username  = "username"
            config.password  = "password"
            config.endpoint  = "https://example.com/ws"
          end
        end

        it "returns a config instance" do
          expect(described_class.config).to be_a(Capita::OneDigital::Configuration)
        end
      end
    end

    describe Capita::OneDigital::Configuration do
      let(:config) { described_class.new }

      context "when not configured" do
        describe "#username" do
          it "raises an error" do
            expect {
              config.username
            }.to raise_error(Capita::OneDigital::ConfigurationError)
          end
        end

        describe "#password" do
          it "raises an error" do
            expect {
              config.password
            }.to raise_error(Capita::OneDigital::ConfigurationError)
          end
        end

        describe "#endpoint" do
          it "raises an error" do
            expect {
              config.endpoint
            }.to raise_error(Capita::OneDigital::ConfigurationError)
          end
        end
      end
    end
  end

  describe "operations" do
    before do
      described_class.configure do |config|
        config.username  = "username"
        config.password  = "password"
        config.endpoint  = "https://example.com/ws"
      end

      savon.expects(operation).with(message: message).returns(response)
    end

    after do
      described_class.reset!
    end

    describe ".delete_profile" do
      let(:operation) { :citizen_portal_delete_profile }

      context "when the request is successful" do
        let(:message) do
          { "tns:username" => "bob@example.com" }
        end

        let(:response) { response_fixture("delete_profile/success.xml") }

        it "returns true" do
          expect(
            described_class.delete_profile("bob@example.com")
          ).to eq(true)
        end
      end

      context "when the request is not successful" do
        let(:message) do
          { "tns:username" => "bob@example.com" }
        end

        let(:response) { response_fixture("delete_profile/error.xml") }

        it "returns false" do
          expect(
            described_class.delete_profile("bob@example.com")
          ).to eq(false)
        end
      end

      context "when the request is invalid" do
        let(:message) do
          { "tns:username" => "bob" }
        end

        let(:response) do
          { status: 500, headers: {}, body: response_fixture("delete_profile/fault.xml") }
        end

        it "raises an error" do
          expect {
            described_class.delete_profile("bob")
          }.to raise_error(Capita::OneDigital::ApiError)
        end
      end
    end

    describe ".edit_profile" do
      let(:operation) { :citizen_portal_edit_profile }

      context "when the request is successful" do
        let(:message) do
          {
            "tns:citizenPortalEditProfileDetails" => {
              "tns:username" => "bob@example.com",
              "tns:dateOfBirth" => "1970-05-06"
            }
          }
        end

        let(:response) { response_fixture("edit_profile/success.xml") }

        it "returns true" do
          expect(
            described_class.edit_profile("bob@example.com", date_of_birth: "1970-05-06")
          ).to eq(true)
        end
      end

      context "when the request is not successful" do
        let(:message) do
          {
            "tns:citizenPortalEditProfileDetails" => {
              "tns:username" => "unknown@example.com",
              "tns:dateOfBirth" => "1970-05-06"
            }
          }
        end

        let(:response) { response_fixture("edit_profile/invalid.xml") }

        it "returns false" do
          expect(
            described_class.edit_profile("unknown@example.com", date_of_birth: "1970-05-06")
          ).to eq(false)
        end
      end

      context "when the request is invalid" do
        let(:message) do
          {
            "tns:citizenPortalEditProfileDetails" => {
              "tns:username" => "bob@example.com",
              "tns:name" => { "tns:firstName" => "Bob" }
            }
          }
        end

        let(:response) { response_fixture("edit_profile/fault.xml") }

        it "raises an error" do
          expect {
            described_class.edit_profile("bob@example.com", name: { first_name: "Bob" })
          }.to raise_error(Capita::OneDigital::ApiError)
        end
      end
    end

    describe ".exists?" do
      let(:operation) { :citizen_portal_profile }

      context "when the request is successful" do
        let(:message) do
          { "tns:username" => "bob@example.com" }
        end

        let(:response) { response_fixture("profile/success.xml") }

        it "returns true" do
          expect(
            described_class.exists?("bob@example.com")
          ).to eq(true)
        end
      end

      context "when the request is not successful" do
        let(:message) do
          { "tns:username" => "bob@example.com" }
        end

        let(:response) { response_fixture("profile/error.xml") }

        it "returns false" do
          expect(
            described_class.exists?("bob@example.com")
          ).to eq(false)
        end
      end

      context "when the request is invalid" do
        let(:message) do
          { "tns:username" => "bob" }
        end

        let(:response) { response_fixture("profile/fault.xml") }

        it "raises an error" do
          expect {
            described_class.exists?("bob")
          }.to raise_error(Capita::OneDigital::ApiError)
        end
      end
    end

    describe ".login_status" do
      let(:operation) { :citizen_portal_log_in_status }

      context "when the request is successful" do
        let(:message) do
          { "tns:token" => "token" }
        end

        let(:response) { response_fixture("login_status/success.xml") }

        it "returns true" do
          expect(
            described_class.login_status("token")
          ).to eq(true)
        end
      end

      context "when the request is not successful" do
        let(:message) do
          { "tns:token" => "notatoken" }
        end

        let(:response) { response_fixture("login_status/invalid.xml") }

        it "returns false" do
          expect(
            described_class.login_status("notatoken")
          ).to eq(false)
        end
      end

      context "when the request is invalid" do
        let(:message) do
          { "tns:token" => "bob@example.com" }
        end

        let(:response) do
          { status: 500, headers: {}, body: response_fixture("delete_profile/fault.xml") }
        end

        it "raises an error" do
          expect {
            described_class.login_status("bob@example.com")
          }.to raise_error(Capita::OneDigital::ApiError)
        end
      end
    end

    describe ".login" do
      let(:operation) { :citizen_portal_third_party_log_in }

      context "when the request is successful" do
        let(:message) do
          { "tns:username" => "bob@example.com" }
        end

        let(:response) { response_fixture("login/success.xml") }

        it "returns the session id" do
          expect(
            described_class.login("bob@example.com")
          ).to eq("token")
        end
      end

      context "when the request is invalid" do
        let(:message) do
          { "tns:username" => "bob" }
        end

        let(:response) do
          { status: 500, headers: {}, body: response_fixture("login/fault.xml") }
        end

        it "raises an error" do
          expect {
            described_class.login("bob")
          }.to raise_error(Capita::OneDigital::ApiError)
        end
      end
    end

    describe ".logout" do
      let(:operation) { :citizen_portal_log_out }

      context "when the request is successful" do
        let(:message) do
          { "tns:token" => "token" }
        end

        let(:response) { response_fixture("logout/success.xml") }

        it "returns true" do
          expect(
            described_class.logout("token")
          ).to eq(true)
        end
      end

      context "when the request is invalid" do
        let(:message) do
          { "tns:token" => "bob@example.com" }
        end

        let(:response) do
          { status: 500, headers: {}, body: response_fixture("logout/fault.xml") }
        end

        it "raises an error" do
          expect {
            described_class.logout("bob@example.com")
          }.to raise_error(Capita::OneDigital::ApiError)
        end
      end
    end

    describe ".profile" do
      let(:operation) { :citizen_portal_profile }

      context "when the request is successful" do
        let(:message) do
          { "tns:username" => "bob@example.com" }
        end

        let(:response) { response_fixture("profile/success.xml") }

        it "returns the profile information" do
          expect(
            described_class.profile("bob@example.com")
          ).to match a_hash_including(
            username: "bob@example.com",
            email: "bob@example.com",
            name: a_hash_including(
              forename: "Bob",
              surname: "Smith"
            ),
            date_of_birth: Date.civil(1968, 10, 31),
            address: a_hash_including(
              address1: "1 Nowhere Road",
              address4: "Hackney",
              address5: "London",
              postcode: "E1 6PP"
            )
          )
        end
      end

      context "when the request is not successful" do
        let(:message) do
          { "tns:username" => "bob@example.com" }
        end

        let(:response) { response_fixture("profile/error.xml") }

        it "returns false" do
          expect(
            described_class.profile("bob@example.com")
          ).to eq(false)
        end
      end

      context "when the request is invalid" do
        let(:message) do
          { "tns:username" => "bob" }
        end

        let(:response) { response_fixture("profile/fault.xml") }

        it "raises an error" do
          expect {
            described_class.profile("bob")
          }.to raise_error(Capita::OneDigital::ApiError)
        end
      end
    end

    describe ".register" do
      let(:operation) { :citizen_portal_register }

      context "when the request is successful" do
        let(:message) do
          { "tns:username" => "bob@example.com", "tns:email" => "bob@example.com" }
        end

        let(:response) { response_fixture("register/success.xml") }

        it "returns true" do
          expect(
            described_class.register("bob@example.com", email: "bob@example.com")
          ).to eq(true)
        end
      end

      context "when the request is not successful" do
        let(:message) do
          { "tns:username" => "bob@example.com", "tns:email" => "bob@example.com" }
        end

        let(:response) { response_fixture("register/invalid.xml") }

        it "returns false" do
          expect(
            described_class.register("bob@example.com", email: "bob@example.com")
          ).to eq(false)
        end
      end

      context "when the request is invalid" do
        let(:message) do
          { "tns:username" => "bob", "tns:email" => "bob" }
        end

        let(:response) { response_fixture("register/fault.xml") }

        it "raises an error" do
          expect {
            described_class.register("bob", email: "bob")
          }.to raise_error(Capita::OneDigital::ApiError)
        end
      end
    end
  end
end
