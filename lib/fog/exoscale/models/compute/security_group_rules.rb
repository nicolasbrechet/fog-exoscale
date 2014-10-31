require 'fog/core/collection'
require 'fog/exoscale/models/compute/security_group_rule'

module Fog
  module Compute
    class Exoscale
      class SecurityGroupRules < Fog::Collection
        model Fog::Compute::Exoscale::SecurityGroupRule

        attribute :security_group_id, type: :string

        def security_group
          service.security_groups.get(security_group_id)
        end

        def create(attributes)
          model = new(attributes.merge(security_group_id: security_group_id))
          model.save
        end

        def all(options = {})
          merge_attributes(options)
          security_group = self.security_group
          rules = security_group.ingress_rules.map { |r| r.merge('direction' => 'ingress', 'security_group_id' => security_group_id) }
          rules += security_group.egress_rules.map { |r| r.merge('direction' => 'egress', 'security_group_id' => security_group_id) }
          load(rules)
        end

        def get(rule_id)
          all.find { |r| r.id == rule_id }
        end
      end
    end
  end
end
