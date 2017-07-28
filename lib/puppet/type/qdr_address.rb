Puppet::Type.newtype(:qdr_address) do
  desc "Type for managing qdrouterd address prefixes for distribution and phasing"

  ensurable do
    defaultto(:present)
    newvalue(:present) do
      provider.create
    end
    newvalue(:absent) do
      provider.destroy
    end
  end

  autorequire(:service) { 'qdrouterd' }

  newparam(:name, :namevar => true) do
    desc "The name of the address prefix"
    newvalues(/^\S+$/)
  end

  newproperty(:prefix) do
    desc "The unique prefix for the address-space"
    newvalues(/^\S+$/)
  end
  
  newproperty(:distribution) do
    desc "The treatment of traffic associated with the address"
    defaultto :balanced
    newvalues(:balanced, :closest, :multicast)
  end

  newproperty(:waypoint) do
    defaultto :false
    newvalues(:true, :false)

    def should_to_s(value)
      value.inspect
    end

    def is_to_s(value)
      value.inspect
    end
    
  end
  
  newproperty(:ingressPhase) do
    desc "Override for the ingress phase for this address"
    defaultto ('0')
#    newvalues(/^d+/)
  end

  newproperty(:egressPhase) do
    desc "Override for the ingress phase for this address"
    defaultto ('0')
#    newvalues(/^d+/)
  end
 
end
