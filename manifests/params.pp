#   Class: qdr::params
#
#   The Qpid Dispatch Router Module configuration settings
#
class qdr::params {
  $service_package_name = 'qpid-dispatch-router'
  $service_name         = 'qdrouterd'
  $package_provider     = 'yum'
  $service_user         = 'qdrouterd'
  $service_group        = 'qdrouterd'
  $service_home         = '/var/lib/qdrouterd'
  $service_version      = '0.6.0'
  $sasl_package_list    = [ 'cyrus-sasl-lib', 'cyrus-sasl-plain' ]
  $tools_package_list   = [ 'qpid-dispatch-tools' ]

  if $::osfamily == 'Debian' {
      $service_package_name = 'qdrouterd'
      $package_provider     = 'apt'
      $sasl_package_list    = 'sasl2-bin'
      $tools_package_list   = [ 'qdmanage' , 'qdstat' ]
  }

  #service and config attributes
  $service_config_path     = '/etc/qpid-dispatch/qdrouterd.conf'
  $service_config_template = 'qdr/qdrouterd.conf.erb'

}
