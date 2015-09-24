# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

# Monkey patching ...
module Boolean; end
class TrueClass; include Boolean; end
class FalseClass; include Boolean; end

describe "Fog::Compute::Exoscale::Zone" do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }
    
    @client = Fog::Compute::Exoscale.new(@config)
  end
  
  describe "when accessing a zone's attributes" do    
    it "must respond to #id" do
      @client.zones.first.must_respond_to :id
      @client.zones.first.id.must_be_kind_of String
    end
        
    it "must respong to #name" do
      @client.zones.first.must_respond_to :name
      @client.zones.first.name.must_be_kind_of String
    end
      
    it "must respong to #domain_id" do
      @client.zones.first.must_respond_to :domain_id
      @client.zones.first.network_type.must_be_kind_of String
    end
      
    it "must respong to #domain_name" do
      @client.zones.first.must_respond_to :domain_name
      @client.zones.first.domain_name.must_be_kind_of NilClass
    end
      
    it "must respong to #network_type" do
      @client.zones.first.must_respond_to :domain_name
      @client.zones.first.domain_name.must_be_kind_of NilClass
    end
      
    it "must respong to #security_groups_enabled" do
      @client.zones.first.must_respond_to :security_groups_enabled
      @client.zones.first.security_groups_enabled.must_be_kind_of Boolean #TrueClass
    end
      
    it "must respong to #allocation_state" do
      @client.zones.first.must_respond_to :allocation_state
      @client.zones.first.allocation_state.must_be_kind_of String
    end
      
    it "must respong to #zone_token" do
      @client.zones.first.must_respond_to :zone_token
      @client.zones.first.zone_token.must_be_kind_of String
    end
      
    it "must respong to #dhcp_provider" do
      @client.zones.first.must_respond_to :dhcp_provider
      @client.zones.first.dhcp_provider.must_be_kind_of String
    end
  end  
  
  describe "when trying to save a zone" do
    it "must respond to #save" do
      @client.zones.new.must_respond_to :save
    end
    
    it "must raise an error" do
      err = lambda { @client.zones.new.save }.must_raise Fog::Errors::Error
      err.message.must_equal "Creating a zone is not supported"
    end
  end
end
