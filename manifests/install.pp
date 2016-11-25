# == Class qdr::install
#
# This class is called from qdr for qdrouterd service installation
class qdr::install inherits qdr {

  $ensure_package       = $::qdr::ensure_package
  $service_package_name = $::qdr::params::service_package_name
  $package_provider     = $::qdr::params::package_provider
  $sasl_package_list    = $::qdr::params::sasl_package_list
  $tools_package_list   = $::qdr::params::tools_package_list

  if $::osfamily == 'Debian' {
      include ::apt

      Class['apt::update'] -> Package<| provider == 'apt' |>

      apt::ppa { 'ppa:qpid/testing' : }
  }

  package { $sasl_package_list :
    ensure   => $ensure_package,
    provider => $package_provider,
  }

  package { $service_package_name :
    ensure   => $ensure_package,
    provider => $package_provider,
    notify   => Class['qdr::service'],
    require  => Package[$sasl_package_list],
  }

  package { $tools_package_list :
    ensure   => $ensure_package,
    provider => $package_provider,
    require  => Package[$service_package_name],
  }

}
