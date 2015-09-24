# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

describe "Fog::Compute::Exoscale::Flavors" do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }
    
    @client = Fog::Compute::Exoscale.new(@config)
  end

  it "must respond to #all" do
    @client.flavors.must_respond_to :all
  end
  
  it "must respond to #get" do
    @client.flavors.must_respond_to :get
  end
  
  it "must return a list of flavors as a non-empty hash" do
    @client.flavors.wont_be_nil
    @client.flavors.all.wont_be_nil
    @client.flavors.must_be_kind_of Fog::Compute::Exoscale::Flavors
    @client.flavors.all.must_be_kind_of Fog::Compute::Exoscale::Flavors
    @client.flavors.count.must_be :>=, 1
    @client.flavors.all.count.must_be :>=, 1
    @client.flavors.count.must_equal @client.flavors.all.count
  end
  
  describe "when getting a specific flavor" do
    before do
      @flavor = @client.flavors.get("a216b0d1-370f-4e21-a0eb-3dfc6302b564")
    end
    
    it "must get the correct flavor" do
      @flavor.id.must_equal "a216b0d1-370f-4e21-a0eb-3dfc6302b564"
      @flavor.cpu_number.must_equal 8
      @flavor.cpu_speed.must_equal 2198
      @flavor.name.must_equal "Huge"
    end
  end
end