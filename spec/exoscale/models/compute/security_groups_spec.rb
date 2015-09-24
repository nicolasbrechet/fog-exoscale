# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

describe "Fog::Compute::Exoscale::Security_Groups" do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }
    
    @client = Fog::Compute::Exoscale.new(@config)
  end
  
  it "must respond to #all" do
    @client.security_groups.must_respond_to :all
  end
  
  it "must respond to #get" do
    @client.security_groups.must_respond_to :get
  end
  
  it "returns a list of security groups as a non-empty hash" do
    @client.security_groups.wont_be_nil
    @client.security_groups.all.wont_be_nil
    @client.security_groups.must_be_kind_of Fog::Compute::Exoscale::SecurityGroups
    @client.security_groups.all.must_be_kind_of Fog::Compute::Exoscale::SecurityGroups
    @client.security_groups.count.must_be :>=, 1
    @client.security_groups.all.count.must_be :>=, 1
    @client.security_groups.count.must_equal @client.security_groups.all.count
  end
end
