# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

# Monkey patching ...
module Boolean; end
class TrueClass; include Boolean; end
class FalseClass; include Boolean; end

describe "Fog::Compute::Exoscale::Image" do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }
    
    @client = Fog::Compute::Exoscale.new(@config)
  end  
  
  describe "when accessing an image's attributes" do
    it "must respond to #id" do
      @client.images.first.must_respond_to :id
      @client.images.first.id.must_be_kind_of String 
    end
      
    it "must respond to #account" do
      @client.images.first.must_respond_to :account
      @client.images.first.account.must_be_kind_of String    
    end
      
    it "must respond to #account_id" do
      @client.images.first.must_respond_to :account_id
      @client.images.first.account_id.must_be_kind_of NilClass    
    end
      
    it "must respond to #bootable" do
      @client.images.first.must_respond_to :bootable
      @client.images.first.bootable.must_be_kind_of NilClass    
    end
      
    it "must respond to #checksum" do
      @client.images.first.must_respond_to :checksum
      @client.images.first.checksum.must_be_kind_of String    
    end
      
    it "must respond to #created" do
      @client.images.first.must_respond_to :created
      @client.images.first.created.must_be_kind_of String    
    end
      
    it "must respond to #cross_zones" do
      @client.images.first.must_respond_to :cross_zones
      @client.images.first.cross_zones.must_be_kind_of Boolean # TrueClass
    end
      
    it "must respond to #details" do
      @client.images.first.must_respond_to :details
      @client.images.first.details.must_be_kind_of NilClass    
    end
      
    it "must respond to #display_text" do
      @client.images.first.must_respond_to :display_text
      @client.images.first.display_text.must_be_kind_of String    
    end
      
    it "must respond to #domain" do
      @client.images.first.must_respond_to :domain
      @client.images.first.domain.must_be_kind_of String    
    end
      
    it "must respond to #domain_id" do
      @client.images.first.must_respond_to :domain_id
      @client.images.first.domain_id.must_be_kind_of String    
    end
      
    it "must respond to #format" do
      @client.images.first.must_respond_to :format
      @client.images.first.format.must_be_kind_of String    
    end
      
    it "must respond to #host_id" do
      @client.images.first.must_respond_to :host_id
      @client.images.first.host_id.must_be_kind_of NilClass    
    end
      
    it "must respond to #host_name" do
      @client.images.first.must_respond_to :host_name
      @client.images.first.host_name.must_be_kind_of NilClass    
    end
      
    it "must respond to #hypervisor" do
      @client.images.first.must_respond_to :hypervisor
      @client.images.first.hypervisor.must_be_kind_of String    
    end
      
    it "must respond to #job_id" do
      @client.images.first.must_respond_to :job_id
      @client.images.first.job_id.must_be_kind_of NilClass    
    end
      
    it "must respond to #job_status" do
      @client.images.first.must_respond_to :job_status
      @client.images.first.job_status.must_be_kind_of NilClass    
    end
      
    it "must respond to #is_extractable" do
      @client.images.first.must_respond_to :is_extractable
      @client.images.first.is_extractable.must_be_kind_of Boolean # TrueClass
    end
      
    it "must respond to #is_featured" do
      @client.images.first.must_respond_to :is_featured
      @client.images.first.is_featured.must_be_kind_of Boolean # FalseClass    
    end
      
    it "must respond to #is_public" do
      @client.images.first.must_respond_to :is_public
      @client.images.first.is_public.must_be_kind_of Boolean # TrueClass    
    end
      
    it "must respond to #is_ready" do
      @client.images.first.must_respond_to :is_ready
      @client.images.first.is_ready.must_be_kind_of Boolean # TrueClass    
    end
      
    it "must respond to #name" do
      @client.images.first.must_respond_to :name
      @client.images.first.name.must_be_kind_of String    
    end
      
    it "must respond to #os_type_id" do
      @client.images.first.must_respond_to :os_type_id
      @client.images.first.os_type_id.must_be_kind_of String    
    end
      
    it "must respond to #os_type_name" do
      @client.images.first.must_respond_to :os_type_name
      @client.images.first.os_type_name.must_be_kind_of String    
    end
      
    it "must respond to #password_enabled" do
      @client.images.first.must_respond_to :password_enabled
      @client.images.first.password_enabled.must_be_kind_of Boolean # TrueClass    
    end
      
    it "must respond to #project" do
      @client.images.first.must_respond_to :project
      @client.images.first.project.must_be_kind_of NilClass    
    end
      
    it "must respond to #project_id" do
      @client.images.first.must_respond_to :project_id
      @client.images.first.project_id.must_be_kind_of NilClass    
    end
      
    it "must respond to #removed" do
      @client.images.first.must_respond_to :removed
      @client.images.first.removed.must_be_kind_of NilClass    
    end
      
    it "must respond to #size" do
      @client.images.first.must_respond_to :size
      @client.images.first.size.must_be_kind_of Fixnum    
    end
      
    it "must respond to #source_template_id" do
      @client.images.first.must_respond_to :source_template_id
      @client.images.first.source_template_id.must_be_kind_of NilClass    
    end
      
    it "must respond to #status" do
      @client.images.first.must_respond_to :status
      @client.images.first.status.must_be_kind_of NilClass    
    end
      
    it "must respond to #template_tag" do
      @client.images.first.must_respond_to :template_tag
      @client.images.first.template_tag.must_be_kind_of NilClass    
    end
      
    it "must respond to #template_type" do
      @client.images.first.must_respond_to :template_type
      @client.images.first.template_type.must_be_kind_of String    
    end
      
    it "must respond to #zone_id" do
      @client.images.first.must_respond_to :zone_id
      @client.images.first.zone_id.must_be_kind_of String    
    end
      
    it "must respond to #zone_name" do
      @client.images.first.must_respond_to :zone_name
      @client.images.first.zone_name.must_be_kind_of String    
    end
      
  end
  
  describe "when trying to save an image" do
    it "must respond to #save" do
      @client.images.new.must_respond_to :save
    end
    
    it "must raise an error" do
      err = lambda { @client.images.new.save }.must_raise Fog::Errors::Error
      err.message.must_equal "Creating an image is not supported"
    end
  end
  
  describe "when trying to delete an image" do
    it "must respond to #destroy" do
      @client.images.first.must_respond_to :destroy
    end
    
    it "must raise an error" do
      err = lambda { @client.images.first.destroy }.must_raise Fog::Errors::Error
      err.message.must_equal "Destroying an image is not supported"
    end
  end
end