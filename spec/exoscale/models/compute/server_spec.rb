# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

# Monkey patching ...
module Boolean; end
class TrueClass; include Boolean; end
class FalseClass; include Boolean; end

describe "Fog::Compute::Exoscale::Server" do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }
    
    @client   = Fog::Compute::Exoscale.new(@config)
    
    # We should create a server before testing
    # Get the id for a "micro" instance. Should be safe even if the ID changes
    micro = @client.list_service_offerings['listserviceofferingsresponse']['serviceoffering'].select { |so| so['name'] == "Micro"}[0]['id']
    
    # Get the id of the first Linux template with 10GB disk
    linux_10gb = @client.list_templates('templatefilter' => 'executable')['listtemplatesresponse']['template'].select {|t| t['zonename']="ch-gva-2" && t["displaytext"].include?("10G Disk") && t["displaytext"].include?("Linux")}.first['id']
    
    # Get the id of the first zone
    zone = @client.zones.first.id
    
    # Request the creation of a server
    jobid = @client.deploy_virtual_machine('templateid' => linux_10gb, 'serviceofferingid' => micro, 'zoneid' => zone)['deployvirtualmachineresponse']['jobid']
    job = @client.jobs.get(jobid)
    job.wait_for { ready? }
    
    @server = @client.servers.get(job.job_result['virtualmachine']['id'])
  end
      
  describe "when a server is created" do
    it "must have a format" do
      @server.must_respond_to :id
      @server.id.must_be_kind_of String

      @server.must_respond_to :name
      @server.name.must_be_kind_of String

      @server.must_respond_to :account_name
      @server.account_name.must_be_kind_of String

      @server.must_respond_to :domain_name
      @server.domain_name.must_be_kind_of String

      @server.must_respond_to :created
      @server.created.must_be_kind_of String

      @server.must_respond_to :state
      @server.state.must_be_kind_of String

      @server.must_respond_to :haenable
      @server.haenable.must_be_kind_of Boolean #FalseClass

      @server.must_respond_to :memory
      @server.memory.must_be_kind_of Fixnum

      @server.must_respond_to :display_name
      @server.display_name.must_be_kind_of String

      @server.must_respond_to :domain_id
      @server.domain_id.must_be_kind_of String

      @server.must_respond_to :host_id
      @server.host_id.must_be_kind_of NilClass

      @server.must_respond_to :host_name
      @server.host_name.must_be_kind_of NilClass

      @server.must_respond_to :project_id
      @server.project_id.must_be_kind_of NilClass

      @server.must_respond_to :zone_id
      @server.zone_id.must_be_kind_of String

      @server.must_respond_to :zone_name
      @server.zone_name.must_be_kind_of String

      @server.must_respond_to :image_id
      @server.image_id.must_be_kind_of String

      @server.must_respond_to :image_name
      @server.image_name.must_be_kind_of String

      @server.must_respond_to :templated_display_text
      @server.templated_display_text.must_be_kind_of String

      @server.must_respond_to :password_enabled
      @server.password_enabled.must_be_kind_of Boolean #TrueClass

      @server.must_respond_to :flavor_id
      @server.flavor_id.must_be_kind_of String

      @server.must_respond_to :flavor_name
      @server.flavor_name.must_be_kind_of String

      @server.must_respond_to :cpu_number
      @server.cpu_number.must_be_kind_of Fixnum

      @server.must_respond_to :cpu_speed
      @server.cpu_speed.must_be_kind_of Fixnum

      @server.must_respond_to :cpu_used
      #@server.cpu_used.must_be_kind_of NilClass

      @server.must_respond_to :network_kbs_read
      @server.network_kbs_read.must_be_kind_of NilClass

      @server.must_respond_to :network_kbs_write
      @server.network_kbs_write.must_be_kind_of NilClass

      @server.must_respond_to :guest_os_id
      @server.guest_os_id.must_be_kind_of String

      @server.must_respond_to :root_device_id
      @server.root_device_id.must_be_kind_of Fixnum

      @server.must_respond_to :root_device_type
      @server.root_device_type.must_be_kind_of String

      @server.must_respond_to :group
      @server.group.must_be_kind_of NilClass

      @server.must_respond_to :key_name
      @server.key_name.must_be_kind_of NilClass

      @server.must_respond_to :user_data
      @server.user_data.must_be_kind_of NilClass

      @server.must_respond_to :security_group_list
      @server.security_group_list.must_be_kind_of Array

      @server.must_respond_to :nics
      @server.nics.must_be_kind_of Array
    end

    it "must respond to requests" do
      @server.must_respond_to :addresses
      @server.must_respond_to :ip_addresses
      @server.must_respond_to :public_ip_addresses
      @server.must_respond_to :private_ip_addresses 
      @server.must_respond_to :private_ip_address
      @server.must_respond_to :destroy
      @server.must_respond_to :flavor
      @server.must_respond_to :ready?
      @server.must_respond_to :reboot
      @server.must_respond_to :security_groups=
      @server.must_respond_to :security_group_ids
      @server.must_respond_to :security_groups
      @server.must_respond_to :save
      @server.must_respond_to :start
      @server.must_respond_to :stop
    end
  end
  
  after do
    @server.destroy
  end
end