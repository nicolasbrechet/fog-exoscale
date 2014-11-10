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
    @images = @client.images
    @image  = @images.get("3235e860-2f00-416a-9fac-79a03679ffd8")
  end  
  
  describe "when trying to create a new image" do
    it "raises an error" do
      assert_raises Fog::Errors::Error do
        @client.images.new.save
      end
    end
  end
  
  describe "when trying to delete an image" do
    it "raises an error" do
      assert_raises Fog::Errors::Error do
        @client.images.first.destroy
      end
    end
  end
  
  it "responds to #save" do
    assert_respond_to @image, :save
  end
  
  it "responds to #destroy" do
    assert_respond_to @image, :destroy
  end
  
  it "responds to #all" do
    assert_respond_to @images, :all
  end
  
  it "responds to #get" do
    assert_respond_to @images, :get
  end
  
  it "returns a list of images as a non-empty hash" do
    @client.images.wont_be_nil
    @client.images.all.wont_be_nil
    @client.images.must_be_kind_of Fog::Compute::Exoscale::Images
    @client.images.all.must_be_kind_of Fog::Compute::Exoscale::Images
    @client.images.count.must_be :>=, 1
    @client.images.all.count.must_be :>=, 1
    @client.images.count.must_equal @client.images.all.count
  end
  
  it "returns an image with format" do
    @client.images.first.id.must_be_kind_of String    
    @client.images.first.account.must_be_kind_of String
    @client.images.first.account_id.must_be_kind_of NilClass
    @client.images.first.bootable.must_be_kind_of NilClass
    @client.images.first.checksum.must_be_kind_of String
    @client.images.first.created.must_be_kind_of String
    @client.images.first.cross_zones.must_be_kind_of TrueClass
    @client.images.first.details.must_be_kind_of NilClass
    @client.images.first.display_text.must_be_kind_of String
    @client.images.first.domain.must_be_kind_of String
    @client.images.first.domain_id.must_be_kind_of String
    @client.images.first.format.must_be_kind_of String
    @client.images.first.host_id.must_be_kind_of NilClass
    @client.images.first.host_name.must_be_kind_of NilClass
    @client.images.first.hypervisor.must_be_kind_of String
    @client.images.first.job_id.must_be_kind_of NilClass
    @client.images.first.job_status.must_be_kind_of NilClass
    @client.images.first.is_extractable.must_be_kind_of TrueClass
    @client.images.first.is_featured.must_be_kind_of FalseClass
    @client.images.first.is_public.must_be_kind_of TrueClass
    @client.images.first.is_ready.must_be_kind_of TrueClass
    @client.images.first.name.must_be_kind_of String
    @client.images.first.os_type_id.must_be_kind_of String
    @client.images.first.os_type_name.must_be_kind_of String
    @client.images.first.password_enabled.must_be_kind_of TrueClass
    @client.images.first.project.must_be_kind_of NilClass
    @client.images.first.project_id.must_be_kind_of NilClass
    @client.images.first.removed.must_be_kind_of NilClass
    @client.images.first.size.must_be_kind_of Fixnum
    @client.images.first.source_template_id.must_be_kind_of NilClass
    @client.images.first.status.must_be_kind_of NilClass
    @client.images.first.template_tag.must_be_kind_of NilClass
    @client.images.first.template_type.must_be_kind_of String
    @client.images.first.zone_id.must_be_kind_of String
    @client.images.first.zone_name.must_be_kind_of String
  end
  
  it "gets the correct image" do
    @image.id.must_equal "3235e860-2f00-416a-9fac-79a03679ffd8"
    @image.account.must_equal "exostack"
    @image.display_text.must_equal "Windows Server 2012 R2 WINRM 100GB Disk"
    @image.zone_id.must_equal "1128bd56-b4d9-4ac6-a7b9-c715b187ce11"
  end
end