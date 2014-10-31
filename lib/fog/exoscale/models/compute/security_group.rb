module Fog
  module Compute
    class Exoscale
      class SecurityGroup < Fog::Model
        identity :id,            aliases: 'id'
        attribute :name,                                     type: :string
        attribute :description,                              type: :string
        attribute :account,                                  type: :string
        attribute :domain_id,     aliases: 'domainid',    type: :string
        attribute :domain_name,   aliases: 'domain',      type: :string
        attribute :project_id,    aliases: 'projectid',   type: :string
        attribute :project_name,  aliases: 'project',     type: :string
        attribute :ingress_rules, aliases: 'ingressrule', type: :array
        attribute :egress_rules,  aliases: 'egressrule',  type: :array

        def destroy
          requires :id
          service.delete_security_group('id' => id)
          true
        end

        def egress_rules
          attributes[:egress_rules] || []
        end

        def ingress_rules
          attributes[:ingress_rules] || []
        end

        def save
          requires :name

          options = {
            'name'        => name,
            'account'     => account,
            'description' => description,
            'projectid'   => project_id,
            'domainid'    => domain_id
          }
          data = service.create_security_group(options)
          merge_attributes(data['createsecuritygroupresponse']['securitygroup'])
        end

        def rules
          service.security_group_rules.all('security_group_id' => id)
        end
      end # SecurityGroup
    end # Exoscale
  end # Compute
end # Fog
