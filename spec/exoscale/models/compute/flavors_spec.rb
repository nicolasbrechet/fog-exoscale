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
    @flavors = @client.flavors
    @flavor = @flavors.get("a216b0d1-370f-4e21-a0eb-3dfc6302b564")
  end
  
  describe "when trying to create a new flavor" do
    it "raises an error" do
      assert_raises Fog::Errors::Error do
        @client.flavors.new.save
      end
    end
  end
  
  describe "when trying to delete a flavor" do
    it "raises an error" do
      assert_raises Fog::Errors::Error do
        @client.flavors.first.destroy
      end
    end
  end

  it "responds to #all" do
    assert_respond_to @flavors, :all
  end
  
  it "responds to #get" do
    assert_respond_to @flavors, :get
  end
    
  it "returns a flavor with format" do
    @client.flavors.first.id.must_be_kind_of String    
    @client.flavors.first.cpu_number.must_be_kind_of Fixnum
    @client.flavors.first.cpu_speed.must_be_kind_of Fixnum
    @client.flavors.first.created.must_be_kind_of String
    @client.flavors.first.default_use.must_be_kind_of FalseClass
    @client.flavors.first.display_text.must_be_kind_of NilClass
    @client.flavors.first.domain.must_be_kind_of NilClass
    @client.flavors.first.host_tags.must_be_kind_of NilClass
    @client.flavors.first.is_system.must_be_kind_of NilClass
    @client.flavors.first.limit_cpu_use.must_be_kind_of FalseClass
    @client.flavors.first.tags.must_be_kind_of NilClass
    @client.flavors.first.system_vm_type.must_be_kind_of NilClass
    @client.flavors.first.storage_type.must_be_kind_of String
    @client.flavors.first.offer_ha.must_be_kind_of FalseClass
    @client.flavors.first.network_rate.must_be_kind_of NilClass
    @client.flavors.first.name.must_be_kind_of String
    @client.flavors.first.memory.must_be_kind_of Fixnum
  end
  
  it "returns a list of flavors as a non-empty hash" do
    @client.flavors.wont_be_nil
    @client.flavors.all.wont_be_nil
    @client.flavors.must_be_kind_of Fog::Compute::Exoscale::Flavors
    @client.flavors.all.must_be_kind_of Fog::Compute::Exoscale::Flavors
    @client.flavors.count.must_be :>=, 1
    @client.flavors.all.count.must_be :>=, 1
    @client.flavors.count.must_equal @client.flavors.all.count
  end
  
  it "gets the correct flavor" do
    @flavor.id.must_equal "a216b0d1-370f-4e21-a0eb-3dfc6302b564"
    @flavor.cpu_number.must_equal 8
    @flavor.cpu_speed.must_equal 2198
    @flavor.name.must_equal "Huge"
  end  
end