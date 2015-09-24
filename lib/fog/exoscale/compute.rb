require "fog/exoscale/core"
require "digest/md5"

module Fog
  module Compute
    class Exoscale < Fog::Service
      
      class MissingRequiredParameter < Fog::Errors::Error; end
      class BadRequest < Fog::Compute::Exoscale::Error; end
      class Unauthorized < Fog::Compute::Exoscale::Error; end
    
      recognizes :exoscale_api_key, :exoscale_secret_access_key 
      recognizes :exoscale_session_key, :exoscale_session_id, :exoscale_persistent
      requires :exoscale_api_key, :exoscale_secret_access_key

      request_path "fog/exoscale/requests/compute"

      model_path "fog/exoscale/models/compute"
      
      model :address

      model :flavor
      collection :flavors
      model :job
      collection :jobs
      model :server
      collection :servers
      model :image
      collection :images
      model :security_group
      collection :security_groups
      model :security_group_rule
      collection :security_group_rules
      model :zone
      collection :zones
      
      # https://community.exoscale.ch/api/compute/
      
      # Virtual Machines
      request :deploy_virtual_machine
      request :destroy_virtual_machine
      request :reboot_virtual_machine
      request :start_virtual_machine
      request :stop_virtual_machine
      request :reset_password_for_virtual_machine
      request :change_service_for_virtual_machine
      request :update_virtual_machine
      request :list_virtual_machines
      request :get_vm_password
      
      # Security Group
      request :create_security_group
      request :delete_security_group
      request :authorize_security_group_ingress
      request :revoke_security_group_ingress
      request :authorize_security_group_egress
      request :revoke_security_group_egress
      request :list_security_groups
      
      # Templates
      request :list_templates
      
      # SSH Keypairs
      request :create_ssh_key_pair
      request :delete_ssh_key_pair
      request :list_ssh_key_pairs
      request :register_ssh_key_pair
      
      # Tags
      request :create_tags
      request :delete_tags
      request :list_tags
      
      # Account
      request :list_accounts
      
      # Events
      request :list_events
      request :list_event_types
      
      # Jobs
      request :query_async_job_result
      request :list_async_jobs
      
      # Cloud
      request :list_zones
      request :list_service_offerings
      
      # This one is not advertised
      request :list_networks
      
      class Real

        def initialize(options={})
          @exoscale_api_key             = options[:exoscale_api_key]
          @exoscale_secret_access_key   = options[:exoscale_secret_access_key]
          @exoscale_session_id          = options[:exoscale_session_id]
          @exoscale_session_key         = options[:exoscale_session_key]
          @host                         = "api.exoscale.ch"
          @path                         = "/compute"
          @port                         = 443
          @scheme                       = "https"
          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", options[:exoscale_persistent], {:ssl_verify_peer => false})
        end

        def reload
          @connection.reset
        end

        def login(username,password,domain)
          response = issue_request({
            "response" => "json",
            "command"  => "login",
            "username" => username,
            "password" => Digest::MD5.hexdigest(password),
            "domain"   => domain
          })

          # Parse response cookies to retrive JSESSIONID token
          cookies   = CGI::Cookie.parse(response.headers["Set-Cookie"])
          sessionid = cookies["JSESSIONID"].first

          # Decode the login response
          response   = Fog::JSON.decode(response.body)

          user = response["loginresponse"]
          user.merge!("sessionid" => sessionid)

          @exoscale_session_id  = user["sessionid"]
          @exoscale_session_key = user["sessionkey"]

          user
        end

        def request(params)
          params.reject!{|k,v| v.nil?}

          params.merge!("response" => "json")

          if has_session?
            params, headers = authorize_session(params)
          elsif has_keys?
            params, headers = authorize_api_keys(params)
          end

          response = issue_request(params,headers)
          response = Fog::JSON.decode(response.body) unless response.body.empty?
          response
        end

      private
        def has_session?
          @exoscale_session_id && @exoscale_session_key
        end

        def has_keys?
          @exoscale_api_key && @exoscale_secret_access_key
        end

        def authorize_session(params)
          # set the session id cookie for the request
          headers = {"Cookie" => "JSESSIONID=#{@exoscale_session_id};"}
          # set the sesion key for the request, params are not signed using session auth
          params.merge!("sessionkey" => @exoscale_session_key)

          return params, headers
        end

        def authorize_api_keys(params)
          headers = {}
          # merge the api key into the params
          params.merge!("apiKey" => @exoscale_api_key)
          # sign the request parameters
          signature = Fog::Exoscale.signed_params(@exoscale_secret_access_key,params)
          # merge signature into request param
          params.merge!({"signature" => signature})

          return params, headers
        end

        def issue_request(params={},headers={},method="GET",expects=200)
          begin
            @connection.request({
              :query => params,
              :headers => headers,
              :method => method,
              :expects => expects
            })

          rescue Excon::Errors::HTTPStatusError => error
            error_response = Fog::JSON.decode(error.response.body)

            error_code = error_response.values.first["errorcode"]
            error_text = error_response.values.first["errortext"]

            case error_code
            when 401
              raise Fog::Compute::Exoscale::Unauthorized, error_text
            when 431
              raise Fog::Compute::Exoscale::BadRequest, error_text
            else
              raise Fog::Compute::Exoscale::Error, error_text
            end
          end

        end
      end # Real

      class Mock
        def initialize(options={})
          @exoscale_api_key           = options[:exoscale_api_key]
          @exoscale_secret_access_key = options[:exoscale_secret_access_key]
        end

        def self.data
          @data ||= begin
            zone_id     = Fog.credentials[:exoscale_zone_id]             || Fog::Exoscale.uuid
            image_id    = Fog.credentials[:exoscale_template_id]         || Fog::Exoscale.uuid
            flavor_id   = Fog.credentials[:exoscale_service_offering_id] || Fog::Exoscale.uuid
            network_id  = (Array(Fog.credentials[:exoscale_network_ids]) || [Fog::Exoscale.uuid]).first
            domain_name = "username@example.org"
            account_id, user_id, domain_id, security_group_id = Fog::Exoscale.uuid, Fog::Exoscale.uuid, Fog::Exoscale.uuid, Fog::Exoscale.uuid
            domain = {
              "id"               => domain_id,
              "name"             => domain_name,
              "level"            => 1,
              "parentdomainid"   => Fog::Exoscale.uuid,
              "parentdomainname" => "ROOT",
              "haschild"         => false,
              "path"             => "ROOT/accountname"
            }
            user = {
              "id"          => user_id,
              "username"    => "elacsoxe",
              "firstname"   => "Foo",
              "lastname"    => "Bar",
              "email"       => "username@example.org",
              "created"     => "2012-05-14T16:25:17-0500",
              "state"       => "enabled",
              "account"     => domain_name,
              "accounttype" => 2,
              "domainid"    => domain_id,
              "domain"      => domain_name,
              "apikey"      => Fog::Exoscale.uuid,
              "secretkey"   => Fog::Exoscale.uuid
            }
            {
              :users    => { user_id    => user },
              :networks => { network_id => {
                "id"                          => network_id,
                "name"                        => "guestNetworkForBasicZone",
                "displaytext"                 => "guestNetworkForBasicZone",
                "broadcastdomaintype"         => "Vlan",
                "traffictype"                 => "Guest",
                "gateway"                     => "185.19.28.1",
                "zoneid"                      => zone_id,
                "zonename"                    => "ch-gva-2",
                "networkofferingid"           => "45964a3a-8a1c-4438-a377-0ff1e264047a",
                "networkofferingname"         => "ExoscaleSharedNetworkOfferingWithSGService",
                "networkofferingdisplaytext"  => "Exoscale Offering for Shared Security group enabled networks",
                "networkofferingconservemode" => false,
                "networkofferingavailability" => "Optional",
                "issystem"                    => false,
                "state"                       => "Setup",
                "related"                     => "00304a04-c7ea-4e77-a786-18bc64347bf7",
                "dns1"                        => "8.8.8.8",
                "dns2"                        => "8.8.4.4",
                "type"                        => "Shared",
                "acltype"                     => "Domain",
                "subdomainaccess"             => true,
                "domainid"                    => domain_id,
                "domain"                      => "ROOT",
                "service" => [
                  {"name" => "UserData"},
                  {
                    "name"       => "Dhcp",
                    "capability" => [
                      {
                        "name"                       => "DhcpAccrossMultipleSubnets", 
                        "value"                      =>"true", 
                        "canchooseservicecapability" =>false
                      }
                    ]
                  },
                  {"name" => "SecurityGroup"}
                ],
                "networkdomain"     => "cs1cloud.internal",
                "physicalnetworkid" => "07f747f5-b445-487f-b2d7-81a5a512989e",
                "restartrequired"   => false,
                "specifyipranges"   => true,
                "canusefordeploy"   => true,
                "ispersistent"      => false,
                "tags"              => [],
                "strechedl2subnet"  => false}
              },
              :zones => { zone_id => {
                "id"                    => zone_id,
                "name"                  => "ch-gva-2",
                "domainid"              => nil,
                "domainname"            => nil,
                "networktype"           => "Basic",
                "securitygroupsenabled" => true,
                "allocationstate"       => "Enabled",
                "zonetoken"             => Fog::Exoscale.uuid,
                "dhcpprovider"          => "VirtualRouter",
                "tags"                  => []}},
              :images => { image_id => {
                "id"                    => image_id,
                "name"                  => "Linux Ubuntu 15.04 64-bit",
                "displaytext"           => "Linux Ubuntu 15.04 64-bit 200G Disk (2015-04-22-c2595b)",
                "ispublic"              => true,
                "created"               => "2015-04-24T16:43:12+0200",
                "isready"               => true,
                "passwordenabled"       => true,
                "format"                => "QCOW2",
                "isfeatured"            => true,
                "crossZones"            => false,
                "ostypeid"              => "113038d0-a8cd-4d20-92be-ea313f87c3ac",
                "ostypename"            => "Other PV (64-bit)",
                "account"               => "exostack",
                "zoneid"                => zone_id,
                "zonename"              => "ch-gva-2",
                "size"                  => "214748364800",
                "templatetype"          => "USER",
                "hypervisor"            => "KVM",
                "domain"                => "ROOT",
                "domainid"              => "4a8857b8-7235-4e31-a7ef-b8b44d180850",
                "isextractable"         => false,
                "checksum"              => "58d9f12c524c684b678de3300b49cff4",
                "tags"                  => [],
                "sshkeyenabled"         => false,
                "isdynamicallyscalable" => false,
              }},
              :flavors => { flavor_id => {
                "id"           => flavor_id,
                "name"         => "Huge",
                "displaytext"  => "Huge 32768mb 8cpu",
                "cpunumber"    => 8,
                "cpuspeed"     => 2198,
                "memory"       => 32768,
                "created"      => "2013-02-08T17:24:10+0100",
                "storagetype"  => "local",
                "offerha"      => false,
                "limitcpuuse"  => false,
                "isvolatile"   => false,
                "issystem"     => false,
                "defaultuse"   => false,
                "iscustomized" => false}},
              :accounts => { account_id => {
                "id"                        => account_id,
                "name"                      => domain_name,
                "accounttype"               => 0,
                "domainid"                  => domain_id,
                "domain"                    => domain_name,
                "vmlimit"                   => 20,
                "vmtotal"                   => 0,
                "vmavailable"               => 20,
                "iplimit"                   => "Unlimited",
                "iptotal"                   => -285,
                "ipavailable"               => 0,
                "volumelimit"               => "Unlimited",
                "volumetotal"               => 1,
                "volumeavailable"           => "Unlimited",
                "snapshotlimit"             => 0,
                "snapshottotal"             => 0,
                "snapshotavailable"         => 0,
                "templatelimit"             => 0,
                "templatetotal"             => 0,
                "templateavailable"         => 0,
                "projectlimit"              => "Unlimited",
                "projecttotal"              => 0,
                "projectavailable"          => "Unlimited",
                "networklimit"              => "Unlimited",
                "networktotal"              => 0,
                "networkavailable"          => "Unlimited",
                "vpclimit"                  => "Unlimited",
                "vpctotal"                  => 0,
                "vpcavailable"              => 0,
                "cpulimit"                  => "Unlimited",
                "cputotal"                  => 0,
                "cpuavailable"              => "Unlimited",
                "memorylimit"               => "Unlimited",
                "memorytotal"               => 0,
                "memoryavailable"           => "Unlimited",
                "primarystoragelimit"       => "Unlimited",
                "primarystoragetotal"       => 0,
                "primarystorageavailable"   => "Unlimited",
                "secondarystoragelimit"     => "Unlimited",
                "secondarystoragetotal"     => 0,
                "secondarystorageavailable" => "Unlimited",
                "state"                     => "enabled",
                "user"                      => [user],
                "isdefault"                 => false,
                "groups"                    => []}
              },
              :domains         => {domain_id => domain},
              :servers         => {},
              :jobs            => {},
              :security_groups => { security_group_id => {
                "id"          => security_group_id,
                "name"        => "default",
                "description" => "Default Security Group",
                "account"     => domain_name,
                "domainid"    => domain_id,
                "domain"      => domain_name,
                "ingressrule" => [],
                "egressrule"  => [],
                "tags"        => [],}
              },
              :snapshots       => {},
              :disk_offerings  => {
                "cc4de87d-672d-4353-abb5-6a8a4c0abf59" => {
                  "id"           => "cc4de87d-672d-4353-abb5-6a8a4c0abf59",
                  "domainid"     => domain_id,
                  "domain"       => domain_name,
                  "name"         => "Small Disk",
                  "displaytext"  => "Small Disk [16GB Disk]",
                  "disksize"     => 16,
                  "created"      => "2013-02-21T03:12:520300",
                  "iscustomized" => false,
                  "storagetype"  =>  "shared"
                },
                "d5deeb0c-de03-4ebf-820a-dc74221bcaeb" => {
                  "id"           => "d5deeb0c-de03-4ebf-820a-dc74221bcaeb",
                  "domainid"     => domain_id,
                  "domain"       => domain_name,
                  "name"         => "Medium Disk",
                  "displaytext"  => "Medium Disk [32GB Disk]",
                  "disksize"     => 32,
                  "created"      => "2013-02-21T03:12:520300",
                  "iscustomized" => false,
                  "storagetype"  => "shared"
                }
              },
              :os_types  => {
                "51ef854d-279e-4e68-9059-74980fd7b29b" => {
                  "id"           => "51ef854d-279e-4e68-9059-74980fd7b29b",
                  "oscategoryid" => "56f67279-e082-45c3-a01c-d290d6cd4ce2",
                  "description"  => "Asianux 3(32-bit)"
                  },
                "daf124c8-95d8-4756-8e1c-1871b073babb" => {
                  "id"           => "daf124c8-95d8-4756-8e1c-1871b073babb",
                  "oscategoryid" => "56f67279-e082-45c3-a01c-d290d6cd4ce2",
                  "description"  => "Asianux 3(64-bit)"
                  }
              }
            }
          end
        end

        def self.reset
          @data = nil
        end

        def data
          self.class.data
        end

        def reset_data
          self.class.data.delete(@exoscale_api_key)
        end
      end
    end # Exoscale
  end # Compute
end # Fog
