# == Class qdr::install
#
# This class is called from qdr for qdrouterd service installation
class qdr::install inherits qdr {

  $package_ensure     = $qdr::package_ensure
  $package_name       = $qdr::package_name
  $tools_ensure       = $qdr::tools_ensure
  $tools_package_name = $qdr::tools_package_name
  
  notice("Inside of qdr install for $package_name")
  package { $package_name:
    ensure => $ackage_ensure,
    name   => $package_name,
  }

  # (TODO:ansmith) should this be in its own class?
  package { $tools_package_name:
    ensure => $tools_ensure,
  }
  
}
