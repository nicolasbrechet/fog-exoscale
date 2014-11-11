# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

describe Fog::Compute::Exoscale do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }
    
    @client   = Fog::Compute::Exoscale.new(@config)
    @servers  = @client.servers
  end
  
  it "must respond to #all" do
    @client.servers.must_respond_to :all
  end
  
  it "must respond to #bootstrap" do
    @client.servers.must_respond_to :bootstrap
  end
  
  it "must respond to #get" do
    @client.servers.must_respond_to :get
  end

end