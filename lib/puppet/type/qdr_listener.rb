Puppet::Type.newtype(:qdr_listener) do
  desc "Type for managing qdrouterd listener instances"

  ensurable 
  
  # this autorequire should not be hard coded
#  autorequire(:service) { 'qdrouterd' }
  newparam(:name, :namevar => true) do
    desc "The unique name for the listener"
  end

  newproperty(:addr) do
    desc "The listening host's IP address, IPv4 or IPv6"
  end

  newproperty(:port) do
    desc "The listeing port number on the host"
  end

  newproperty(:role) do
    desc "The role for connections established by the listener"
    defaultto :normal
    newvalues(:normal, :inter_router, :on_demand)
  end

  newproperty(:auth_peer) do
    defaultto :no
    newvalues(:yes, :no)

    def should_to_s(value)
      value.inspect
    end

    def is_to_s(value)
      value.inspect
    end
    
  end

end
