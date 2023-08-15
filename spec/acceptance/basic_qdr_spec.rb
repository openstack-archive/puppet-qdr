require 'spec_helper_acceptance'

describe 'basic qdr' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include openstack_integration
      include openstack_integration::repos

      # NOTE(tkajinam): qpid dispatch router is not available for Ubuntu Jammy
      if $facts['os']['family'] == 'RedHat' {
        class { 'qdr':
          listener_addr          => $::openstack_integration::config::host,
          listener_port          => $::openstack_integration::config::messaging_default_port,
          listener_sasl_mech     => 'PLAIN',
          listener_auth_peer     => true,
          router_worker_threads  => 2,
        }

        qdr_user { 'testuser':
          password => 'secret',
          provider => 'sasl',
          require  => Class['qdr'],
        }
      }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end
end
