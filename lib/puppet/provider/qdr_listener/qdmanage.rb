require "json"

Puppet::Type.type(:qdr_listener).provide(:qdmanage) do

  # should rely on environment rather fq path
  commands :qdmanage => '/usr/bin/qdmanage'
 
  def self.instances
    begin
      listeners = json.load(execute("/usr/bin/qdmanage QUERY --type=listener"))


  
#    parsed["name"].each do |name|
#      notice("Found a name")
    end
  end
  
  def create
    begin
      qdmanage('CREATE',
               '--type=listener',
               '--name',
               resource[:name],
               'addr='+resource[:addr],
               'port='+resource[:port],
               'role='+resource[:role].to_s)             
    rescue Puppet::ExecutionFailure => e
      false
    end
  end
  
  def destroy
    notice("Listener destroy not supported")
    true
  end
  
  def exists?
    begin
      qdmanage('READ',
               '--type=listener',
               '--name',
               resource[:name])
      true
    rescue Puppet::ExecutionFailure => e
      false
    end
  end

 def addr
    begin
      listener=JSON.load(qdmanage('READ',
                                 '--type=listener',
                                  '--name',
                                  resource[:name]))
      addr=listener["addr"]
    rescue Puppet::ExecutionFailure => e
      addr=empty
    end
  end

  def addr=(value)
    notice("Listener update address not supported")
    true
  end

 def port
    begin
      listener=JSON.load(qdmanage('READ',
                                 '--type=listener',
                                  '--name',
                                  resource[:name]))
      port=listener["port"]
    rescue Puppet::ExecutionFailure => e
      port=empty
    end 
 end

  def port=(value)
    notice("Listener port value update not supported")
    true
  end  

  def role
    begin
      listener=JSON.load(qdmanage('READ',
                                 '--type=listener',
                                  '--name',
                                  resource[:name]))
      role=listener["role"]
    rescue Puppet::ExecutionFailure => e
      role=empty
    end
  end

  def role=(value)
    notice("Listener role value update not supported")
  end

  def auth_peer
    begin
      listener=JSON.load(qdmanage('READ',
                                 '--type=listener',
                                  '--name',
                                  resource[:name]))
      auth_peer=listener["auth_peer"]
    rescue Puppet::ExecutionFailure => e
      auth_peer=empty
    end
  end

  def auth_peer=(value)
    notice("Listener auth_peer value update not supported")
    true
  end  
  
end
