#   Class: qdr::params
#
#   The Qpid Dispatch Router Module configuration settings
#
class qdr::params {

  if ($::os['name'] == 'Fedora') or
    ($::os['family'] == 'RedHat' and Integer.new($::os['release']['major']) > 7) {
    $_package_provider = 'dnf'
  } else {
    $_package_provider = 'yum'
  }
  case $::osfamily {
    'Debian': {
      $service_package_name = 'qdrouterd'
      $service_name         = 'qdrouterd'
      $service_config_path  = '/etc/qpid-dispatch/qdrouterd.conf'
      $package_provider     = 'apt'
      $service_user         = 'qdrouterd'
      $service_group        = 'qdrouterd'
      $service_home         = '/var/lib/qdrouterd'
      $service_version      = '1.5.0'
      $sasl_package_list    = 'sasl2-bin'
      $tools_package_list   = [ 'qdmanage' , 'qdstat' ]
    }
    'RedHat': {
      $service_package_name = 'qpid-dispatch-router'
      $service_name         = 'qdrouterd'
      $service_config_path  = '/etc/qpid-dispatch/qdrouterd.conf'
      $package_provider     = $_package_provider
      $service_user         = 'qdrouterd'
      $service_group        = 'qdrouterd'
      $service_home         = '/var/lib/qdrouterd'
      $service_version      = '1.5.0'
      $sasl_package_list    = [ 'cyrus-sasl-lib', 'cyrus-sasl-plain' ]
      $tools_package_list   = [ 'qpid-dispatch-tools' ]
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, \
module ${module_name} only support osfamily RedHat and Debian")
    }
  }

}
