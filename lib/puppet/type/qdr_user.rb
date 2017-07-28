Puppet::Type.newtype(:qdr_user) do
  desc "Type for managing qdr users such as with sasl provider, etc."

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
    desc "The name of user"
    newvalues(/^\S+$/)
  end

  newparam(:password) do
    desc "The user password to be set on creation"
  end

  validate do
    if self[:ensure] == :present and ! self[:password]
      raise Puppet::Error => 'Must set password when creating user' unless self[:password]
    end
  end

end
