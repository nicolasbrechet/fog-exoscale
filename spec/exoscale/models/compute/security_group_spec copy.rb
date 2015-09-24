# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

describe "Fog::Compute::Exoscale" do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }
    
    @client = Fog::Compute::Exoscale.new(@config)
  end
  
  describe "when accessing a SG's attributes" do
    it "must respond to #id" do
      @client.security_groups.first.must_respond_to :id
      @client.security_groups.first.id.must_be_kind_of String 
    end
    
    it "must respond to #name" do
      @client.security_groups.first.must_respond_to :name
      @client.security_groups.first.name.must_be_kind_of String 
    end
    
    it "must respond to #description" do
      @client.security_groups.first.must_respond_to :description
      @client.security_groups.first.description.must_be_kind_of String
    end
    
    it "must respond to #account" do
      @client.security_groups.first.must_respond_to :account
      @client.security_groups.first.account.must_be_kind_of String
    end
    
    it "must respond to #domain_id" do
      @client.security_groups.first.must_respond_to :domain_id
      @client.security_groups.first.domain_id.must_be_kind_of String
    end
    
    it "must respond to #domain_name" do
      @client.security_groups.first.must_respond_to :domain_name
      @client.security_groups.first.domain_name.must_be_kind_of String
    end
    
    it "must respond to #project_id" do
      @client.security_groups.first.must_respond_to :project_id
      @client.security_groups.first.project_id.must_be_kind_of NilClass
    end
    
    it "must respond to #project_name" do
      @client.security_groups.first.must_respond_to :project_name
      @client.security_groups.first.project_name.must_be_kind_of NilClass
    end
    
    it "must respond to #ingress_rules" do
      @client.security_groups.first.must_respond_to :ingress_rules
      @client.security_groups.first.ingress_rules.must_be_kind_of Array
    end
    
    it "must respond to #egress_rules" do
      @client.security_groups.first.must_respond_to :egress_rules
      @client.security_groups.first.egress_rules.must_be_kind_of Array
    end
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
