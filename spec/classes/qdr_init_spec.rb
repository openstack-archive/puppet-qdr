require 'spec_helper'

describe 'qdr' do

  shared_examples 'qdr' do

    it { is_expected.to contain_class('qdr') }
    it { is_expected.to contain_class('qdr::params') }
    it { is_expected.to contain_class('qdr::install') }
    it { is_expected.to contain_class('qdr::config') }
    it { is_expected.to contain_class('qdr::service') }

    it 'installs the service package' do
      is_expected.to contain_package(platform_params[:qdr_package_name]).with({ :ensure => :installed })
    end

    it 'installs the sasl packages' do
      platform_params[:sasl_package_list].each do |p|
        is_expected.to contain_package(p).with({ :ensure => :installed })
      end
    end

    it 'installs the tools packages' do
      platform_params[:tools_package_list].each do |p|
        is_expected.to contain_package(p).with({ :ensure => :installed })
      end
    end

    context 'with default parameters' do
      it do
        should contain_file(platform_params[:service_home]).with({
          :ensure => :directory,
          :owner  => '0',
          :group  => '0',
          :mode   => '0755',
        })
      end

      it do
        should contain_file('/etc/qpid-dispatch').with({
          :ensure => :directory,
          :owner  => '0',
          :group  => '0',
          :mode   => '0644',
        })
      end

      it do
        should contain_file('/etc/qpid-dispatch/ssl').with({
          :ensure => :directory,
          :owner  => '0',
          :group  => '0',
          :mode   => '0644',
        })
      end

      it do
        should contain_file('qdrouterd.conf').with({
          :ensure => :file,
          :owner  => '0',
          :group  => '0',
          :mode   => '0644',
        })
      end

      it do
        should contain_file(platform_params[:router_debug_dump]).with({
          :ensure => :directory,
          :owner  => '0',
          :group  => '0',
          :mode   => '0766',
        })
      end

      it do
        should contain_service(platform_params[:service_name]).with({
          :ensure => 'running',
          :enable => 'true',
        })
      end

      it do
        should contain_file('qdrouterd.conf').with_content(/mode: standalone/)
        should contain_file('qdrouterd.conf').with_content(/workerThreads: 8/)
        should contain_file('qdrouterd.conf').with_content(/helloIntervalSeconds: 1/)
        should contain_file('qdrouterd.conf').with_content(/helloMaxAgeSeconds: 3/)
        should contain_file('qdrouterd.conf').with_content(/raIntervalSeconds: 30/)
        should contain_file('qdrouterd.conf').with_content(/raIntervalFluxSeconds: 4/)
        should contain_file('qdrouterd.conf').with_content(/remoteLsMaxAgeSeconds: 60/)
        should contain_file('qdrouterd.conf').with_content(/host: 127.0.0.1/)
        should contain_file('qdrouterd.conf').with_content(/port: 5672/)
        should contain_file('qdrouterd.conf').with_content(/authenticatePeer: false/)
        should contain_file('qdrouterd.conf').with_content(/idleTimeoutSeconds: 16/)
        should contain_file('qdrouterd.conf').with_content(/maxFrameSize: 16384/)
        should contain_file('qdrouterd.conf').with_content(/requireEncryption: false/)
        should contain_file('qdrouterd.conf').with_content(/saslMechanisms: ANONYMOUS/)
        should contain_file('qdrouterd.conf').without_content(/sslProfile {/)
        should contain_file('qdrouterd.conf').without_content(/connector {/)
      end

    end

    context 'with overridden paramters' do

      let :params do
        {
          :router_worker_threads    => '4',
          :router_hello_interval    => 2,
          :router_hello_max_age     => 6,
          :router_ra_interval       => 60,
          :router_ra_interval_flux  => 8,
          :router_remote_ls_max_age => 120,
          :listener_addr            => '10.1.1.1',
          :listener_port            => '5671',
          :listener_auth_peer       => true,
          :listener_idle_timeout    => '32',
          :listener_max_frame_size  => '32768',
          :listener_require_encrypt => true,
          :listener_sasl_mech       => 'ANONYMOUS DIGEST-MD5 EXTERNAL PLAIN',
          :connectors               => [{'role' => 'inter-router'}],
          :extra_listeners          => [{'mode' => 'interior'}],
          :extra_addresses          => [{'prefix' => 'exclusive'}],
        }
      end

      it do
        should contain_file('qdrouterd.conf').with_content(/workerThreads: 4/)
        should contain_file('qdrouterd.conf').with_content(/helloIntervalSeconds: 2/)
        should contain_file('qdrouterd.conf').with_content(/helloMaxAgeSeconds: 6/)
        should contain_file('qdrouterd.conf').with_content(/raIntervalSeconds: 60/)
        should contain_file('qdrouterd.conf').with_content(/raIntervalFluxSeconds: 8/)
        should contain_file('qdrouterd.conf').with_content(/remoteLsMaxAgeSeconds: 120/)
        should contain_file('qdrouterd.conf').with_content(/host: 10.1.1.1/)
        should contain_file('qdrouterd.conf').with_content(/port: 5671/)
        should contain_file('qdrouterd.conf').with_content(/authenticatePeer: true/)
        should contain_file('qdrouterd.conf').with_content(/idleTimeoutSeconds: 32/)
        should contain_file('qdrouterd.conf').with_content(/maxFrameSize: 32768/)
        should contain_file('qdrouterd.conf').with_content(/requireEncryption: true/)
        should contain_file('qdrouterd.conf').with_content(/saslMechanisms: ANONYMOUS DIGEST-MD5 EXTERNAL PLAIN/)
        should contain_file('qdrouterd.conf').with_content(/role: inter-router/)
        should contain_file('qdrouterd.conf').with_content(/mode: interior/)
        should contain_file('qdrouterd.conf').with_content(/prefix: exclusive/)
      end

    end

    context 'with qdr ssl enabled' do

      let :params do
        {
          :listener_require_ssl   => true,
          :listener_ssl_cert_db   => '/etc/ssl/certs/ca-bundle.crt',
          :listener_ssl_cert_file => '/etc/pki/ca-trust/source/anchors/puppet_qdr.pem',
          :listener_ssl_key_file  => '/etc/qpid-dispatch/ssl/puppet_qdr.pem',
        }
      end

      it do
        should contain_file('qdrouterd.conf').with_content(/sslProfile {/)
        should contain_file('qdrouterd.conf').with_content(/certDb: \/etc\/ssl\/certs\/ca-bundle.crt/)
        should contain_file('qdrouterd.conf').with_content(/certFile: \/etc\/pki\/ca-trust\/source\/anchors\/puppet_qdr.pem/)
        should contain_file('qdrouterd.conf').with_content(/keyFile: \/etc\/qpid-dispatch\/ssl\/puppet_qdr.pem/)
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :os_workers  => 8,
        }))
      end

      let (:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          {
            :qdr_package_name   => 'qdrouterd',
            :service_name       => 'qdrouterd',
            :sasl_package_list  => ['sasl2-bin'],
            :tools_package_list => ['qdmanage' , 'qdstat'],
            :service_home       => '/var/lib/qdrouterd',
            :router_debug_dump  => '/var/log/qdrouterd'
          }
        when 'RedHat'
          {
            :qdr_package_name   => 'qpid-dispatch-router',
            :service_name       => 'qdrouterd',
            :sasl_package_list  => ['cyrus-sasl-lib','cyrus-sasl-plain'],
            :tools_package_list => ['qpid-dispatch-tools'],
            :service_home       => '/var/lib/qdrouterd',
            :router_debug_dump  => '/var/log/qdrouterd'
          }
        end
      end

      it_behaves_like 'qdr'

    end
  end
end
