
Puppet::Type.type(:qdr_user).provide(:sasl) do

  commands :saslpasswd2 => 'saslpasswd2'
  optional_commands :sasldblistusers2 => 'sasldblistusers2'

  def self.instances
    users = []
    userlist=sasldblistusers2('-f', '/var/lib/qdrouterd/qdrouterd.sasldb').split(/\n/).each do |line|
      if line =~ /^(\S+)@(\S+):.*$/
        users << new(:name   => $1,
                     :ensure => :present)
      else
        raise Puppet::Error, "Cannot parse invalid user line: #{line}"
      end
    end
    users
  end

  def create
    # is there a way to pipe to commands?
    if not system(%{echo "#{resource[:password]}" | saslpasswd2 -f '/var/lib/qdrouterd/qdrouterd.sasldb' #{resource[:name]}})

      raise Puppet::Error, "Failed to create user"
    end
    system("chmod '0644' '/var/lib/qdrouterd/qdrouterd.sasldb'")
  end

  def destroy
    saslpasswd2('-f', '/var/lib/qdrouterd/qdrouterd.sasldb', '-d', resource[:name])
  rescue Puppet::ExecutionFailure => e
    return
  end

  def exists?
    begin
      users = sasldblistusers2('-f', "/var/lib/qdrouterd/qdrouterd.sasldb").split(/\n/).detect do |user|
        user.match(/^#{resource[:name]}@.*$/)
      end
    rescue
      return false
    end 
  end
end
