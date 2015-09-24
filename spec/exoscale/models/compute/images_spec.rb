# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

describe "Fog::Compute::Exoscale::Images" do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }
    
    @client = Fog::Compute::Exoscale.new(@config)
  end  
  
  it "must respond to #all" do
    @client.images.must_respond_to :all
  end
  
  it "must respond to #get" do
    @client.images.must_respond_to :get
  end
  
  it "must return a list of images as a non-empty hash" do
    @client.images.wont_be_nil
    @client.images.all.wont_be_nil
    @client.images.must_be_kind_of Fog::Compute::Exoscale::Images
    @client.images.all.must_be_kind_of Fog::Compute::Exoscale::Images
    @client.images.count.must_be :>=, 1
    @client.images.all.count.must_be :>=, 1
    @client.images.count.must_equal @client.images.all.count
  end
  
  describe "when getting a specific image" do
    before do
      @image = @client.images.get("17bfb3ee-50a7-4434-8acc-f2807bd9ed60")
    end
    
    it "must get the correct image" do
      @image.id.must_equal "17bfb3ee-50a7-4434-8acc-f2807bd9ed60"
      @image.account.must_equal "exostack"
      @image.display_text.must_equal "Linux Debian 7 64-bit 10GB Disk"
      @image.zone_id.must_equal "1128bd56-b4d9-4ac6-a7b9-c715b187ce11"
    end
  end
end