# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

# Monkey patching ...
module Boolean; end
class TrueClass; include Boolean; end
class FalseClass; include Boolean; end

describe "Fog::Compute::Exoscale::Flavor" do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }
    
    @client = Fog::Compute::Exoscale.new(@config)
  end
  
  describe "when accessing a flavor's attributes" do
    it "must respond to #id" do
      @client.flavors.first.must_respond_to :id
      @client.flavors.first.id.must_be_kind_of String 
    end
    
    it "must respond to #cpu_number" do 
      @client.flavors.first.must_respond_to :cpu_number
      @client.flavors.first.cpu_number.must_be_kind_of Fixnum
    end
    
    it "must respond to #cpu_speed" do
      @client.flavors.first.must_respond_to :cpu_speed
      @client.flavors.first.cpu_speed.must_be_kind_of Fixnum
    end
      
    it "must respond to #created" do
      @client.flavors.first.must_respond_to :created
      @client.flavors.first.created.must_be_kind_of String
    end
    
    it "must respond to #default_use" do
      @client.flavors.first.must_respond_to :default_use
      @client.flavors.first.default_use.must_be_kind_of Boolean #FalseClass
    end
    
    it "must respond to #display_text" do
      @client.flavors.first.must_respond_to :display_text
      @client.flavors.first.display_text.must_be_kind_of NilClass
    end
    
    it "must respond to #domain" do
      @client.flavors.first.must_respond_to :domain
      @client.flavors.first.domain.must_be_kind_of NilClass
    end
    
    it "must respond to #host_tags" do
      @client.flavors.first.must_respond_to :host_tags
      @client.flavors.first.host_tags.must_be_kind_of NilClass
    end
    
    it "must respond to #is_system" do
      @client.flavors.first.must_respond_to :is_system
      @client.flavors.first.is_system.must_be_kind_of NilClass
    end
    
    it "must respond to #limit_cpu_use" do
      @client.flavors.first.must_respond_to :limit_cpu_use
      @client.flavors.first.limit_cpu_use.must_be_kind_of Boolean #FalseClass
    end
    
    it "must respond to #tags" do
      @client.flavors.first.must_respond_to :tags
      @client.flavors.first.tags.must_be_kind_of NilClass
    end
    
    it "must respond to #system_vm_type" do
      @client.flavors.first.must_respond_to :system_vm_type
      @client.flavors.first.system_vm_type.must_be_kind_of NilClass
    end
    
    it "must respond to #storage_type" do
      @client.flavors.first.must_respond_to :storage_type
      @client.flavors.first.storage_type.must_be_kind_of String
    end
    
    it "must respond to #offer_ha" do
      @client.flavors.first.must_respond_to :offer_ha
      @client.flavors.first.offer_ha.must_be_kind_of Boolean #FalseClass
    end
    
    it "must respond to #network_rate" do
      @client.flavors.first.must_respond_to :network_rate
      @client.flavors.first.network_rate.must_be_kind_of NilClass
    end
    
    it "must respond to #name" do
      @client.flavors.first.must_respond_to :name
      @client.flavors.first.name.must_be_kind_of String
    end
    
    it "must respond to #memory" do
      @client.flavors.first.must_respond_to :memory
      @client.flavors.first.memory.must_be_kind_of Fixnum
    end
  end
  
  describe "when trying to save a flavor" do
    it "must respond to #save" do
      @client.flavors.new.must_respond_to :save
    end
    
    it "must raise an error" do
      err = lambda { @client.flavors.new.save }.must_raise Fog::Errors::Error
      err.message.must_equal "Creating a flavor is not supported"
    end
  end
  
  describe "when trying to destroy a flavor" do
    it "must respond to #destroy" do
      @client.flavors.new.must_respond_to :destroy
    end
    
    it "must raise an error" do
      err = lambda { @client.flavors.first.destroy }.must_raise Fog::Errors::Error
      err.message.must_equal "Destroying a flavor is not supported"
    end
  end
end