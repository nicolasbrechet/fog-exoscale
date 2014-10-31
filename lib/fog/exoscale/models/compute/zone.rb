module Fog
  module Compute
    class Exoscale
      class Zone < Fog::Model
        identity :id,                          aliases: 'id'
        attribute :name
        attribute :domain_id,                   aliases: 'domainid'
        attribute :domain_name,                 aliases: %w(domainname domain)
        attribute :network_type,                aliases: 'networktype'
        attribute :security_groups_enabled,     aliases: %w(securitygroupsenabled securitygroupenabled)
        attribute :allocation_state,            aliases: 'allocationstate'
        attribute :zone_token,                  aliases: 'zonetoken'
        attribute :dhcp_provider,               aliases: 'dhcpprovider'

        attr_accessor :dns1, :dns2, :internaldns1, :internaldns2, :guest_cidr_address

        def save
          fail Fog::Errors::Error.new('Creating a zone is not supported')
        end
      end # Zone
    end # Exoscale
  end # Compute
end # Fog
