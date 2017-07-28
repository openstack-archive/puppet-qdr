Puppet::Type.newtype(:qdr_connector) do
  desc "Type for managing qdrouterd connection instances"

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
    desc "The unique name for the connector"
    newvalues(/^\s*\S+\s*$/)
  end

  newproperty(:addr) do
    desc "The outgoing connection host's IP address, IPv4 or IPv6"
  end

  newproperty(:port) do
    desc "The outgoing connection host port number"
    newvalues(/^\d+/)
  end

  newproperty(:role) do
    desc "The role for connections established by the listener"
    defaultto :normal
    newvalues(:normal, :inter_router, :on_demand)
  end

  newproperty(:sasl_mechanisms) do
    desc "List of accepted SASL authentication mechansisms"
    defaultto "ANONYMOUS,DIGEST-MD5,EXTERNAL,PLAIN"
  end
  
  newproperty(:allowRedirect) do
    defaultto :false
    newvalues(:true, :false)

    def should_to_s(value)
      value.inspect
    end

    def is_to_s(value)
      value.inspect
    end
  end

  newproperty(:max_frame_size) do
    desc "The largest contiguous set of uninterrupted data that can be sent"
    defaultto ('65536')

    validate do |value|
      unless value =~ /\d{1,5}/ &&
             value.to_i <= 65536
        fail("Invalid max frame size #{value}")
      end
    end
  end

  newproperty(:idle_timeout_seconds) do
    desc "The largest contiguous set of uninterrupted data that can be sent"
    defaultto ('16')

    # what would the validation be? Max timeout value?
  end  
  
  newproperty(:strip_annotations) do
    defaultto :both
    newvalues(:in, :out, :both, :no)

    def should_to_s(value)
      value.inspect
    end

    def is_to_s(value)
      value.inspect
    end
  end

end
