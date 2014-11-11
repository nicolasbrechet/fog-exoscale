# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

describe Fog::Compute::Exoscale do
  describe "when global config is available" do
    before do
      @config = {
        :exoscale_api_key           => ENV["EXO_API_KEY"],
        :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
      }

      @service = Fog::Compute::Exoscale.new(@config)
    end

    it "must respond to #request" do
      @service.must_respond_to :request
    end
    
    it "must respond to collection #flavors" do
      @service.must_respond_to :flavors
    end
    
    it "must respond to collection #jobs" do
      @service.must_respond_to :jobs
    end
    
    it "must respond to collection #servers" do
      @service.must_respond_to :servers
    end
    
    it "must respond to collection #images" do
      @service.must_respond_to :images
    end
    
    it "must respond to collection #security_groups" do
      @service.must_respond_to :security_groups
    end
    
    it "must respond to collection #security_group_rules" do
      @service.must_respond_to :security_group_rules
    end
    
    it "must respond to collection #zones" do
      @service.must_respond_to :zones
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
