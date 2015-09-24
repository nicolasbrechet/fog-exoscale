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
  end
  
  describe "when creating a server with a new SG, new rules, new keypair" do
    before do      
      @ssh_key_pair         = @client.create_ssh_key_pair(:name => "fog_test_keypair_#{Random.new.rand(1..2000)}")['createsshkeypairresponse']['keypair']
      
      @security_group       = @client.create_security_group(:name => "fog_test_sg_#{Random.new.rand(1..2000)}")['createsecuritygroupresponse']['securitygroup']
      
      ingress_job_id        = @client.authorize_security_group_ingress(:securityGroupName => @security_group['name'],
                                                                       :cidrList => '0.0.0.0/0', 
                                                                       :startPort => '22', 
                                                                       :endPort => '22', 
                                                                       :protocol => 'TCP')['authorizesecuritygroupingressresponse']['jobid']
                                                                       
      Fog.wait_for { 
        @ingress_rule_id = @client.query_async_job_result(:jobId => ingress_job_id)['queryasyncjobresultresponse']['jobresult']['securitygroup']['ingressrule'][0]['ruleid']
      }
      
      egress_job_id         = @client.authorize_security_group_egress(:securityGroupName => @security_group['name'], 
                                                                      :cidrList => '0.0.0.0/0',
                                                                      :startPort => '22',
                                                                      :endPort => '22',
                                                                      :protocol => 'TCP')['authorizesecuritygroupegressresponse']['jobid']
      Fog.wait_for { 
        @egress_rule_id = @client.query_async_job_result(:jobId => egress_job_id)['queryasyncjobresultresponse']['jobresult']['securitygroup']['egressrule'][0]['ruleid']
      }
      
      @security_group       = @client.list_security_groups['listsecuritygroupsresponse']['securitygroup'].select{|sg| sg['name']==@security_group['name']}[0]
                            
      @template_id          = @client.list_templates('templatefilter' => 'executable')['listtemplatesresponse']['template'].select{|t| t['name'].include? "Linux"}.first['id']
      @zone_id              = @client.list_zones['listzonesresponse']['zone'].first['id']
      @service_offering_id  = @client.list_service_offerings['listserviceofferingsresponse']['serviceoffering'].select{|so| so['name']=="Micro"}.first['id']
      
      instance_job_id       = @client.deploy_virtual_machine('templateid' => @template_id, 'zoneid' => @zone_id, 'serviceofferingid' => @service_offering_id, 'securitygroupids' => @security_group['id'], 'keypair' => @ssh_key_pair['name'])['deployvirtualmachineresponse']['jobid']
      instance_job          = @client.jobs.get(instance_job_id)
      instance_job.wait_for { ready? }
      @server_id = instance_job.job_result['virtualmachine']['id']
      
      @server               = @client.servers.get(@server_id)
    end
    
    it "should have the correct SG, SG rules, keypair" do
      @server.security_groups.first.id.must_equal @security_group['id']
      @server.security_groups.first.ingress_rules.first['ruleid'].must_equal @ingress_rule_id
      @server.security_groups.first.egress_rules.first['ruleid'].must_equal @egress_rule_id
      @server.key_name.must_equal @ssh_key_pair['name']
    end    
    
    
    after do
      # - destroy the server
      @client.destroy_virtual_machine('id' => @server_id)
            
      # - destroy the SG      
      begin
        @client.delete_security_group('id' => @security_group['id'])
      rescue Fog::Compute::Exoscale::Error => e
        if e.message == "Cannot delete group when it's in use by virtual machines"
          sleep 30
          retry
        else
          raise Fog::Compute::Exoscale::Error, :message => e.message
        end
      end
      
      # - destroy the keypair
      @client.delete_ssh_key_pair('name' => @ssh_key_pair['name'])
    end     
    
  end

end
