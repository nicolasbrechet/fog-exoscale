require 'fog/core'
require 'fog/xml'
require 'fog/exoscale'

def security_group_tests(provider, params, mocks_implemented = true)
	collection_tests(provider.security_groups, params, mocks_implemented) do

		if Fog.mocking? && !mocks_implemented
			pending
		else
			responds_to(:rules)
		end

	end
end

provider, config = :exoscale, compute_providers[:exoscale]
Shindo.tests("Fog::Compute[:#{provider}] | security_group", [provider.to_s]) do

	security_group_tests(Fog::Compute[provider], (config[:security_group_attributes] || {}), config[:mocked])

end
