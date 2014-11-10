# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

describe Fog::Compute::Exoscale do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }
    
    @client = Fog::Compute::Exoscale.new(@config)
  end

  it "responds to #zones" do
    assert_respond_to @client, :zones
  end

  it "responds to #list_zones" do
    assert_respond_to @client, :list_zones
  end

  it "responds to #all" do
    assert_respond_to @client.zones, :all
  end
  
  it "responds to #get" do
    assert_respond_to @client.zones, :get
  end
  
  it "responds to #save" do
    assert_respond_to @client.zones.new, :save
  end

  it "returns the zones collection " do
    @client.zones.wont_be_nil
  end
  
  describe "when trying to create a new zone" do
    it "raises an error" do
      assert_raises Fog::Errors::Error do
        @client.zones.new.save
      end
    end
  end

  it "returns a list of zones as a non-empty hash" do
    @client.list_zones.wont_be_nil
    @client.list_zones.must_be_kind_of Hash
    @client.list_zones["listzonesresponse"]["count"].must_be :>=, 1
  end
  
  it "lists a zone with format" do
    @client.list_zones["listzonesresponse"]["zone"].first["id"].must_be_kind_of String
    @client.list_zones["listzonesresponse"]["zone"].first["name"].must_be_kind_of String
    @client.list_zones["listzonesresponse"]["zone"].first["networktype"].must_be_kind_of String
    @client.list_zones["listzonesresponse"]["zone"].first["securitygroupsenabled"].must_be_kind_of TrueClass
    @client.list_zones["listzonesresponse"]["zone"].first["allocationstate"].must_be_kind_of String
    @client.list_zones["listzonesresponse"]["zone"].first["zonetoken"].must_be_kind_of String
    @client.list_zones["listzonesresponse"]["zone"].first["dhcpprovider"].must_be_kind_of String
    @client.list_zones["listzonesresponse"]["zone"].first["localstorageenabled"].must_be_kind_of TrueClass
    @client.list_zones["listzonesresponse"]["zone"].first["tags"].must_be_kind_of Array
  end
  
  it "returns a collection of zone with format" do
    @client.zones.first.id.must_be_kind_of String
    @client.zones.first.name.must_be_kind_of String
    @client.zones.first.network_type.must_be_kind_of String
    @client.zones.first.security_groups_enabled.must_be_kind_of TrueClass
    @client.zones.first.allocation_state.must_be_kind_of String
    @client.zones.first.zone_token.must_be_kind_of String
    @client.zones.first.dhcp_provider.must_be_kind_of String
  end
end
