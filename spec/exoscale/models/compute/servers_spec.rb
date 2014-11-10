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
  
  it "responds to #all" do
    assert_respond_to @client.servers, :all
  end
  
  it "responds to #bootstrap" do
    assert_respond_to @client.servers, :bootstrap
  end
  
  it "responds to #get" do
    assert_respond_to @client.servers, :get
  end
  
  it "responds to #addresses" do
    assert_respond_to @client.servers.new, :addresses
  end
    
  it "responds to #ip_addresses" do
    assert_respond_to @client.servers.new, :ip_addresses
  end
  
  it "responds to #public_ip_addresses" do
    assert_respond_to @client.servers.new, :public_ip_addresses
  end
  
  it "responds to #private_ip_addresses" do
    assert_respond_to @client.servers.new, :private_ip_addresses
  end
  
  it "responds to #private_ip_address" do
    assert_respond_to @client.servers.new, :private_ip_address
  end
  
  it "responds to #destroy" do
    assert_respond_to @client.servers.new, :destroy
  end
  
  it "responds to #flavor" do
    assert_respond_to @client.servers.new, :flavor
  end
  
  it "responds to #ready?" do
    assert_respond_to @client.servers.new, :ready?
  end
  
  it "responds to #reboot" do
    assert_respond_to @client.servers.new, :reboot
  end
  
  it "responds to #security_groups=" do
    assert_respond_to @client.servers.new, :security_groups=
  end
  
  it "responds to #security_group_ids" do
    assert_respond_to @client.servers.new, :security_group_ids
  end
  
  it "responds to #security_groups" do
    assert_respond_to @client.servers.new, :security_groups
  end
  
  it "responds to #save" do
    assert_respond_to @client.servers.new, :save
  end
  
  it "responds to #start" do
    assert_respond_to @client.servers.new, :start
  end
  
  it "responds to #stop" do
    assert_respond_to @client.servers.new, :stop
  end
  
  
  
end