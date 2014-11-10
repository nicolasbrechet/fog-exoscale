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
  
  it "responds to #list_security_groups" do
    assert_respond_to @client, :list_security_groups
  end
  
  it "responds to #security_groups" do
    assert_respond_to @client, :security_groups
  end
  
  it "responds to #all" do
    assert_respond_to @client.security_groups, :all
  end
  
  it "responds to #get" do
    assert_respond_to @client.security_groups, :get
  end
  
  it "responds to #destroy" do
    assert_respond_to @client.security_groups.new, :destroy
  end
  
  it "responds to #egress_rules" do
    assert_respond_to @client.security_groups.new, :egress_rules
  end
  
  it "responds to #ingress_rules" do
    assert_respond_to @client.security_groups.new, :ingress_rules
  end
  
  it "responds to #save" do
    assert_respond_to @client.security_groups.new, :save
  end
  
  it "responds to #rules" do
    assert_respond_to @client.security_groups.new, :rules
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
  
  it "lists a security group with format" do
    @client.list_security_groups["listsecuritygroupsresponse"]["securitygroup"].first["id"].must_be_kind_of String
    @client.list_security_groups["listsecuritygroupsresponse"]["securitygroup"].first["name"].must_be_kind_of String
    @client.list_security_groups["listsecuritygroupsresponse"]["securitygroup"].first["description"].must_be_kind_of String
    @client.list_security_groups["listsecuritygroupsresponse"]["securitygroup"].first["account"].must_be_kind_of String
    @client.list_security_groups["listsecuritygroupsresponse"]["securitygroup"].first["domainid"].must_be_kind_of String
    @client.list_security_groups["listsecuritygroupsresponse"]["securitygroup"].first["domain"].must_be_kind_of String
    @client.list_security_groups["listsecuritygroupsresponse"]["securitygroup"].first["ingressrule"].must_be_kind_of Array
    @client.list_security_groups["listsecuritygroupsresponse"]["securitygroup"].first["egressrule"].must_be_kind_of Array
    @client.list_security_groups["listsecuritygroupsresponse"]["securitygroup"].first["tags"].must_be_kind_of Array
  end
  
  it "returns a security group with format" do
    @client.security_groups.first.id.must_be_kind_of String    
    @client.security_groups.first.name.must_be_kind_of String
    @client.security_groups.first.description.must_be_kind_of String
    @client.security_groups.first.account.must_be_kind_of String
    @client.security_groups.first.domain_id.must_be_kind_of String
    @client.security_groups.first.domain_name.must_be_kind_of String
    @client.security_groups.first.project_id.must_be_kind_of NilClass
    @client.security_groups.first.project_name.must_be_kind_of NilClass
    @client.security_groups.first.ingress_rules.must_be_kind_of Array
    @client.security_groups.first.egress_rules.must_be_kind_of Array
  end
end
