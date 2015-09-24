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
  
  describe "when creating a new security group" do
    before do
      @count_of_sg = @client.list_security_groups['listsecuritygroupsresponse']['count']
      @new_sg = @client.create_security_group(:name => "fog_test_sg_#{Random.new.rand(1..2000)}")['createsecuritygroupresponse']['securitygroup']
    end
  
    it "must have one more security group" do
      @client.list_security_groups['listsecuritygroupsresponse']['count'].must_equal @count_of_sg + 1
    end
    
    it "must list the new security group" do
      @client.list_security_groups['listsecuritygroupsresponse']['securitygroup'].select{|sg| sg['name']==@new_sg['name']}[0]['id'].must_equal @new_sg['id']
    end
    
    after do
      begin
        @client.delete_security_group(:name => @new_sg['name'])
      rescue Fog::Compute::Exoscale::Error => e
        if e.message == "Cannot delete group when it's in use by virtual machines"
          sleep 30
          retry
        else
          raise Fog::Compute::Exoscale::Error, :message => e.message
        end
      end
    end
  end
  
  describe "when authorizing rules to a new security group" do
    before do
      @another_sg = @client.create_security_group(:name => "fog_exoscale_test_sg_rules_#{Random.new.rand(1..2000)}")['createsecuritygroupresponse']['securitygroup']
      # empty security group
    end
    
    it "must have no rules" do
      @another_sg['ingressrule'].must_be_empty
      @another_sg['egressrule'].must_be_empty
    end
    
    describe "When adding new rules" do
      before do
        # adding an ingress rule:
        #  keeping the job id
        ingress_job_id = @client.authorize_security_group_ingress(:securityGroupName => @another_sg['name'], :cidrList => '0.0.0.0/0', :startPort => '22', :endPort => '22', :protocol => 'TCP')['authorizesecuritygroupingressresponse']['jobid']
        Fog.wait_for { 
          @ingress_rule_id = @client.query_async_job_result(:jobId => ingress_job_id)['queryasyncjobresultresponse']['jobresult']['securitygroup']['ingressrule'][0]['ruleid']
        }
        
        # and same for egress rule
        egress_job_id = @client.authorize_security_group_egress(:securityGroupName => @another_sg['name'], :cidrList => '0.0.0.0/0', :startPort => '22', :endPort => '22', :protocol => 'TCP')['authorizesecuritygroupegressresponse']['jobid']
        Fog.wait_for { 
          @egress_rule_id = @client.query_async_job_result(:jobId => egress_job_id)['queryasyncjobresultresponse']['jobresult']['securitygroup']['egressrule'][0]['ruleid']
        }
        
        @another_sg = @client.list_security_groups['listsecuritygroupsresponse']['securitygroup'].select{|sg| sg['name']==@another_sg['name']}[0]
      end
      
      it "must list new rules" do
        @another_sg['ingressrule'][0]['ruleid'].must_equal @client.list_security_groups['listsecuritygroupsresponse']['securitygroup'].select{|sg| sg['name']==@another_sg['name']}[0]['ingressrule'][0]['ruleid']
        @another_sg['egressrule'][0]['ruleid'].must_equal @client.list_security_groups['listsecuritygroupsresponse']['securitygroup'].select{|sg| sg['name']==@another_sg['name']}[0]['egressrule'][0]['ruleid']
      end
      
      after do
        @client.revoke_security_group_ingress('id' => @ingress_rule_id) unless @ingress_rule_id.nil?
        @client.revoke_security_group_egress('id' => @egress_rule_id) unless @egress_rule_id.nil?
      end
    end    
    
    after do
      begin
        @client.delete_security_group(:name => @another_sg['name'])
      rescue Fog::Compute::Exoscale::Error => e
        if e.message == "Cannot delete group when it's in use by virtual machines"
          sleep 30
          retry
        else
          raise Fog::Compute::Exoscale::Error, :message => e.message
        end
      end
    end
  end
end