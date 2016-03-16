# == Class qdr::config
#
# This class is called from qdr for qdrouterd service configuration
#
class qdr::config inherits qdr {

  $service_config_path     = $qdr::service_config_path
  $service_config_template = $qdr::service_config_template
  $service_home            = $qdr::service_home
  
  file { '/etc/qdrouterd' :
    ensure => directory,
    owner  => '0',
    group  => '0',
    mode   => '0644',
  }
  
  file { 'qdrouterd.conf' :
    ensure  => file,
    path    => $service_config_path,
    content => template($service_config_template),
    owner   => '0',
    group   => '0',
    mode    => '0644',
    notify  => Class['qdr::service'],
  }

  file { $service_home :
    ensure => directory,
    owner  => '0',
    group  => '0',
    mode   => '0644',
  }
  
  # TODO(ansmith) - is there need for service conf files, etc.
}
