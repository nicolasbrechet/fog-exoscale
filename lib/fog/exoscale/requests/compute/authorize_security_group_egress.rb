module Fog
  module Compute
    class Exoscale
      class Real
        # Authorizes a particular egress rule for this security group
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/authorizeSecurityGroupEgress.html]
        def authorize_security_group_egress(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'authorizeSecurityGroupEgress')
          else
            options.merge!('command' => 'authorizeSecurityGroupEgress')
          end
          request(options)
        end
      end

      class Mock
        def authorize_security_group_egress(options = {})
          security_group_id      = options['securitygroupid']
          security_group_rule_id = Fog::Exoscale.uuid

          unless cidr = options['cidrlist']
            fail Fog::Compute::Exoscale::BadRequest.new('Unable to execute API command missing parameter cidr')
          end

          unless start_port = options['startport']
            fail Fog::Compute::Exoscale::BadRequest.new('Unable to execute API command missing parameter start_port')
          end

          unless end_port = options['endport']
            fail Fog::Compute::Exoscale::BadRequest.new('Unable to execute API command missing parameter end_port')
          end

          unless protocol = options['protocol']
            fail Fog::Compute::Exoscale::BadRequest.new('Unable to execute API command missing parameter protocol')
          end

          rule = {
            'ruleid'    => security_group_rule_id,
            'cidr'      => cidr,
            'startport' => start_port,
            'endport'   => end_port,
            'protocol'  => protocol
          }

          unless security_group = data[:security_groups][security_group_id]
            fail Fog::Compute::Exoscale::BadRequest.new("Security group id #{security_group_id} does not exist")
          end

          security_group['egressrule'] ||= []
          security_group['egressrule'] << rule

          job_id = Fog::Exoscale.uuid
          job = {
            'cmd'           => 'com.cloud.api.commands.authorizeSecurityGroupEgress',
            'created'       => Time.now.iso8601,
            'jobid'         => job_id,
            'jobstatus'     => 1,
            'jobprocstatus' => 0,
            'jobresultcode' => 0,
            'jobresulttype' => 'object',
            'jobresult'     => { 'securitygroup' => security_group }
          }

          data[:jobs][job_id] = job

          { 'authorizesecuritygroupegressresponse' => { 'jobid' => job_id } }
        end
      end
    end
  end
end
