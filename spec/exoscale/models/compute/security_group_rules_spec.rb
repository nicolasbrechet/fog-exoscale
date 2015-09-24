# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

describe "Fog::Compute::Exoscale::Security_Group_Rules" do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }
    
    @client = Fog::Compute::Exoscale.new(@config)
    @security_group = @client.security_groups.first
  end
  
  it "must respond to #security_group" do
    @security_group.rules.must_respond_to :security_group
  end
  
  it "must respond to #create" do
    @security_group.rules.must_respond_to :create
  end
  
  it "must respond to #all" do
    @security_group.rules.must_respond_to :all
  end
  
  it "must respond to #get" do
    @security_group.rules.must_respond_to :get
  end
  
  it "returns a list of SG rules" do
    @security_group.rules.all.must_be_kind_of Fog::Compute::Exoscale::SecurityGroupRules
    @security_group.rules.all.first.must_be_kind_of Fog::Compute::Exoscale::SecurityGroupRule
  end
  
  describe "when geting a specific SG rule" do
    before do
      @rule_id = @client.security_groups.first.rules.first.id
    end
    
    it "gets a SG rule" do
      @security_group.rules.get(@rule_id).id.must_equal @rule_id
    end
  end
end
