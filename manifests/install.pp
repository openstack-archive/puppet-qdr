# == Class qdr::install
#
# This class is called from qdr for qdrouterd service installation
class qdr::install inherits qdr {

  $package_ensure     = $qdr::package_ensure
  $package_name       = $qdr::package_name
  $package_provider   = $qdr::package_provider
  $sasl_package_list  = $qdr::sasl_package_list
  $tools_package_name = $qdr::tools_package_name

  case $::osfamily{
    'RedHat': {
      package { $sasl_package_list :
        ensure   => 'installed',
        provider => $package_provider,
      }

      package { $package_name :
        ensure   => 'installed',
        provider => $package_provider,
        notify   => Class['qdr::service'],
        require  => Package[$sasl_package_list],
      }

      # (TODO:ansmith) should this have a require?
      package { $tools_package_name :
        ensure   => 'installed',
        provider => $package_provider,
        require  => Package[$package_name],
      }
    }
    'Debian': {
      include apt

      Class['apt::update'] -> Package<| provider == 'apt' |>

      apt::ppa { 'ppa:qpid/testing' : }

      package { 'qdrouterd' :
        ensure   => 'running',
        name     => 'qdrouterd',
        provider => apt
      }

      package { 'qdmanage' :
        ensure   => 'installed',
        provider => apt
      }

      package { 'qdstat' :
        ensure   => 'installed',
        provider => apt
      }
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily}.")
    }
  }
}
