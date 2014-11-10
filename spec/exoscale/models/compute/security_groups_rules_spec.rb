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
    @security_group = @client.security_groups.first
    @sg_rule = @security_group.rules.first
  end
  
  it "responds to #security_group" do
    assert_respond_to  @security_group.rules, :security_group
  end
  it "responds to #create" do
    assert_respond_to  @security_group.rules, :create
  end
  it "responds to #all" do
    assert_respond_to  @security_group.rules, :all
  end
  it "responds to #get" do
    assert_respond_to  @security_group.rules, :get
  end
  
  it "responds to #security_group" do
    assert_respond_to @sg_rule, :security_group
  end  
  it "responds to #destroy" do
    assert_respond_to @sg_rule, :destroy
  end
  it "responds to #port_range" do
    assert_respond_to @sg_rule, :port_range
  end
  it "responds to #save" do
    assert_respond_to @sg_rule, :save
  end
  it "responds to #reload" do
    assert_respond_to @sg_rule, :reload
  end
  
  it "returns a list of SG rules" do
    @security_group.rules.all.must_be_kind_of Fog::Compute::Exoscale::SecurityGroupRules
    @security_group.rules.all.first.must_be_kind_of Fog::Compute::Exoscale::SecurityGroupRule
  end
  
  it "gets a SG rule" do
    @security_group.rules.get(@sg_rule.id).id.must_equal @sg_rule.id
  end
  
  #create an ingress rule
  #create an egress rule
  
end
