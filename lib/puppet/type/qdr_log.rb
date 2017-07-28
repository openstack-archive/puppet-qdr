Puppet::Type.newtype(:qdr_log) do
  desc "Type for managing qdrouterd module log instances"

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
    desc "The unique name for the log module"
  end

  newproperty(:module) do
    desc "The qdrouterd log module source"
  end

end
