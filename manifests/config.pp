# == Class qdr::config
#
# This class is called from qdr for qdrouterd service configuration
#
class qdr::config inherits qdr {
  
  notice("Inside of qdr config")
  
  file { "/etc/qpid-dispatch/qdrouterd.conf" :
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template('qdr/qdrouterd.conf.erb'),
    }
}
