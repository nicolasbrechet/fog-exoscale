# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

describe "Fog::Compute::Exoscale::Zones" do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }
    
    @client = Fog::Compute::Exoscale.new(@config)
  end

  it "must respond to #all" do
    @client.zones.must_respond_to :all
  end
  
  it "must respond to #get" do
    @client.zones.must_respond_to :get
  end
  
  it "must return a list of zones as a non-empty hash" do
    @client.zones.wont_be_nil
    @client.zones.all.wont_be_nil
    @client.zones.must_be_kind_of Fog::Compute::Exoscale::Zones
    @client.zones.all.must_be_kind_of Fog::Compute::Exoscale::Zones
    @client.zones.count.must_be :>=, 1
    @client.zones.all.count.must_be :>=, 1
    @client.zones.count.must_equal @client.zones.all.count
  end
  
  describe "when getting a specific zone" do
    before do
      @zone = @client.zones.get("1128bd56-b4d9-4ac6-a7b9-c715b187ce11")
    end
    
    it "must get the correct zone" do
      @zone.id.must_equal "1128bd56-b4d9-4ac6-a7b9-c715b187ce11"
      @zone.name.must_equal "ch-gva-2"
      @zone.network_type.must_equal "Basic"
    end
  end
end
