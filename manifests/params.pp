#   Class: qdr::params
#
#   The Qpid Dispatch Router Module configuration settings
#
class qdr::params {

  case $::osfamily {
    'RedHat': {
      $package_ensure  = latest
      $package_name    = 'qpid-dispatch-router'
      $service_name    = 'qdrouterd'
      $service_user    = 'qdrouterd'
      $service_group   = 'qdrouterd'
      $version         = '0.5.0'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }

  #service and config attributes
  $service_config_file  = '/etc/qpid-dispatch/qdrouterd.conf'
  $service_password     = 'qdrpassword'
  $service_ensure       = running
  $service_enable       = true
  $service_manage       = true
  
  # container attributes
  $container_name           = "Qpid.Dispatch.Router.$::hostname"
  $container_worker_threads = $::processorcount
  $container_debug_dump     = '/var/log/'
  $container_sasl_path      = '/etc/sasl2'
  $container_sasl_name      = 'qdrouterd'
    
  # router attributes
  $router_id                  = "Router.$::fqdn"
  $router_mode                = 'standalone'
  $router_hello_interval      = '1'
  $router_hello_max_age       = '3'
  $router_ra_interval         = '30'
  $router_ra_interval_flux    = '4'
  $router_remote_ls_max_age   = '60'
  $router_mobile_addr_max_age = '60'

  # listener attributes
  $listener_addr            = '127.0.0.1'
  $listener_port            = '5672'
  $listener_ssl_cert_db     = 'UNSET'
  $listener_ssl_cert_file   = 'UNSET'
  $listener_ssl_key_file    = 'UNSET'
  $listener_ssl_pw_file     = 'UNSET'
  $listener_ssl_password    = undef
  $listener_sasl_mech       = 'ANONYMOUS,DIGEST-MD5,EXTERNAL,PLAIN'
  $listener_auth_peer       = 'no'
  $listener_require_encrypt = 'no'
  $listener_require_ssl     = 'no'
  $listener_trusted_certs   = 'UNSET'
  $listener_max_frame_size  = '65536'
  $listener_idle_timout     = '16'
  
  # log parameters
  $log_module           = 'DEFAULT'
  $log_enable           = 'debug+'
  $log_output           = '/var/log/qdrouterd.log'

  # tools package
  $tools_ensure         = 'installed'
  $tools_package_name   = 'qpid-dispatch-tools'
}
