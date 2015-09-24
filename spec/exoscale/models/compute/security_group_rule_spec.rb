# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

describe "Fog::Compute::Exoscale::Security_Group_Rule" do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }
    
    @client = Fog::Compute::Exoscale.new(@config)
  end
  
  describe "when accessing a SG Rule's attributes" do
    before do
      @sg = @client.security_groups.first
    end
    
    it "must respond to #id" do
      @sg.rules.first.must_respond_to :id
      @sg.rules.first.id.must_be_kind_of String 
    end  

    it "must respond to #security_group_id" do
      @sg.rules.first.must_respond_to :security_group_id
      @sg.rules.first.security_group_id.must_be_kind_of String
    end
    
    it "must respond to #protocol" do
      @sg.rules.first.must_respond_to :protocol
      @sg.rules.first.protocol.must_be_kind_of String
    end
    
    it "must respond to #start_port" do
      @sg.rules.first.must_respond_to :start_port
      @sg.rules.first.start_port.must_be_kind_of Fixnum
    end
    
    it "must respond to #end_port" do
      @sg.rules.first.must_respond_to :end_port
      @sg.rules.first.end_port.must_be_kind_of Fixnum
    end
    
    it "must respond to #cidr" do
      @sg.rules.first.must_respond_to :cidr
      @sg.rules.first.cidr.must_be_kind_of String
    end
    
    it "must respond to #direction" do
      @sg.rules.first.must_respond_to :direction
      @sg.rules.first.direction.must_be_kind_of String
    end
  end
  
end
