module Fog
  module Compute
    class Exoscale
      class SecurityGroupRule < Fog::Model
        identity :id,                aliases: 'ruleid'

        attribute :security_group_id, type: :string
        attribute :protocol,          type: :string
        attribute :start_port,        type: :integer, aliases: 'startport'
        attribute :end_port,          type: :integer, aliases: 'endport'
        attribute :cidr,              type: :string
        attribute :direction,         type: :string

        def destroy
          data = service.send("revoke_security_group_#{direction}", 'id' => id)
          job = service.jobs.new(data["revokesecuritygroup#{direction}"])
          job.wait_for { ready? }
          job.successful?
        end

        def port_range
          (start_port..end_port)
        end

        def save
          requires :security_group_id, :cidr, :direction

          data = service.send("authorize_security_group_#{direction}".to_sym, params)
          job = service.jobs.new(data["authorizesecuritygroup#{direction}response"])
          job.wait_for { ready? }
          # durty
          merge_attributes(job.result.send("#{direction}_rules").last)
          self
        end

        def security_group
          service.security_groups.get(security_group_id)
        end

        def reload
          requires :id, :security_group_id, :cidr

          merge_attributes(security_group.rules.get(id))
        end

        private

        def params
          options = {
            'securitygroupid' => security_group_id,
            'protocol'        => protocol,
            'cidrlist'        => cidr
          }
          options.merge!('startport' => start_port) unless start_port.nil?
          options.merge('endport' => end_port) unless end_port.nil?
        end
      end # SecurityGroupRule
    end # Exoscale
  end # Compute
end # Fog
