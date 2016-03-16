# == Class qdr::install
#
# This class is called from qdr for qdrouterd service installation
class qdr::install inherits qdr {

  $package_ensure     = $qdr::package_ensure
  $package_name       = $qdr::package_name
  $package_provider   = $qdr::package_provider
  $sasl_package_list  = $qdr::sasl_package_list
  $tools_package_name = $qdr::tools_package_name
  
  package { $sasl_package_list :
    ensure   => 'installed',
    provider => $package_provider,
  }

  package { 'qdrouterd' :
    ensure   => $package_ensure,
    name     => $package_name,
    provider => $package_provider,
    notify   => Class['qdr::service'],
    require  => Package[$sasl_package_list],
  }

  # (TODO:ansmith) should this have a require?
  package { $tools_package_name :
    ensure   => $package_ensure,
    name     => $tools_package_name,
    provider => $package_provider,
  }
  
}
