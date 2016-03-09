Puppet::Type.newtype(:qdr_connector) do
  desc "Type for managing qdrouterd connection instances"

  ensurable

  # TODO(ansmith) - dynamic autorequired for qdrouterd service
  # autorequire(:service) { "qdrouterd' }

  newparam(:name, :namevar => true) do
    desc "The unique name for the connector"
  end

  newproperty(:addr) do
    desc "The outgoing connection host's IP address, IPv4 or IPv6"
  end

  newproperty(:port) do
    desc "The outgoing connection host port number"
  end

  newproperty(:role) do
    desc "The role for connections established by the listener"
    defaultto :normal
    newvalues(:normal, :inter_router, :on_demand)
  end

end
