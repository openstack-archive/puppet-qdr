require "json"

Puppet::Type.type(:qdr_address).provide(:qdmanage) do

  # should rely on environment rather fq path
  commands :qdmanage => '/usr/bin/qdmanage'

  mk_resource_methods

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def self.get_list_of_addresses
    begin
      @addresses=JSON.load(qdmanage('QUERY','--type=address'))
    rescue Puppet::ExecutionFailure => e
      @addresses = {}
    end
  end

  def self.get_address_properties(address)
    address_properties = {}
 
    address_properties[:provider]     = :qdmanage
    address_properties[:ensure]       = :present
    address_properties[:name]         = address["name"]
    address_properties[:prefix]       = address["prefix"]
    address_properties[:distribution] = address["distribution"]
    address_properties[:waypoint]     = address["waypoint"].to_s
    address_properties[:ingressPhase] = address["ingressPhase"]
    address_properties[:egressPhase]  = address["egressPhase"]
    
    address_properties
  end   

  def self.instances
    addresses = []
    get_list_of_addresses.each do |address|
      addresses << new( :prefix => address["prefix"],
                        :name => address["name"],
                        :ensure => :present,
                        :distribution => address["distribution"],
                        :waypoint => address["waypoint"].to_s,
                        :ingressPhase => address["ingressPhase"],
                        :egressPhase => address["egressPhase"])
    end
    addresses                    
  end
  
  def create
    @property_flush[:ensure] = :present
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    @property_flush[:ensure] = :absent
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.prefix]
        resource.provider = prov
      end
    end
  end

  def set_address
    # TODO(ansmith) - full CRUD once supported by qdmanage
    if @property_flush[:ensure] == :absent
      notice("Address destroy not supported")
      return
    end

    begin
      # TODO(ansmith) - prefix uniqueness check
      qdmanage('CREATE',
               '--type=address',
               '--prefix',
               resource[:prefix],
               'distribution='+resource[:distribution],
               'waypoint='+resource[:waypoint].to_s,
               'ingressPhase='+resource[:ingressPhase],
               'egressPhase='+resource[:egressPhase])
    rescue Puppet::ExecutionFailure => e
      return
    end
    
  end
  
  def flush
    set_address

    @property_hash = self.class.get_address_properties(resource[:prefix])
  end

end
