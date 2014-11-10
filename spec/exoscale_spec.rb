require "minitest/autorun"
require "fog/exoscale"

describe Fog::Compute::Exoscale do
  describe "when global config is available" do
    before do
      @config = {
        :exoscale_api_key           => "bogus_api_key",
        :exoscale_secret_access_key => "bogus_secret_access_key"
      }

      @service = Fog::Compute::Exoscale.new(@config)
    end

    it "responds to #request" do
      assert_respond_to @service, :request
    end
  end

  describe "when created without required arguments" do
    it "raises an error" do
      Fog.stub :credentials, {} do
        assert_raises ArgumentError do
          Fog::Compute::Exoscale.new({})
        end
      end
    end
  end
end
