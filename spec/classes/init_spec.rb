require 'spec_helper'

describe 'qdr' do

  shared_examples 'qdr' do

    it { is_expected.to contain_class('qdr') }
    it { is_expected.to contain_class('qdr::params') }
    it { is_expected.to contain_class('qdr::install') }
    it { is_expected.to contain_class('qdr::config') }
    it { is_expected.to contain_class('qdr::service') }

    it 'installs packages' do
      is_expected.to contain_package(platform_params[:qdr_package_name]).with({ :ensure => :installed })
      platform_params[:sasl_package_list].each do |p|
        is_expected.to contain_package(p).with({ :ensure => :installed })
      end
    end

    context 'with default parameters' do
      it do
        should contain_file(platform_params[:service_home]).with({
          :ensure => :directory,
          :owner  => '0',
          :group  => '0',
          :mode   => '0644',
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
        should contain_service(platform_params[:service_name]).with({
          :ensure => 'running',
          :enable => 'true',
        })
      end

      it do
        should contain_file('qdrouterd.conf').with_content(/mode: standalone/)
        should contain_file('qdrouterd.conf').with_content(/workerThreads: 8/)
        should contain_file('qdrouterd.conf').with_content(/host: 127.0.0.1/)
        should contain_file('qdrouterd.conf').with_content(/port: 5672/)
        should contain_file('qdrouterd.conf').with_content(/authenticatePeer: no/)
        should contain_file('qdrouterd.conf').with_content(/saslMechanisms: ANONYMOUS/)
        should contain_file('qdrouterd.conf').without_content(/sslProfile {/)
      end

    end

    context 'with overridden paramters' do

      let :params do
        {
          :router_worker_threads => '4',
          :listener_addr         => '10.1.1.1',
          :listener_port         => '5671',
          :listener_auth_peer    => 'yes',
          :listener_sasl_mech    => 'ANONYMOUS DIGEST-MD5 EXTERNAL PLAIN'
        }
      end

      it do
        should contain_file('qdrouterd.conf').with_content(/workerThreads: 4/)
        should contain_file('qdrouterd.conf').with_content(/host: 10.1.1.1/)
        should contain_file('qdrouterd.conf').with_content(/port: 5671/)
        should contain_file('qdrouterd.conf').with_content(/authenticatePeer: yes/)
        should contain_file('qdrouterd.conf').with_content(/saslMechanisms: ANONYMOUS DIGEST-MD5 EXTERNAL PLAIN/)
      end

    end

    context 'with qdr ssl enabled' do

      let :params do
        {
          :listener_require_ssl   => 'yes',
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

      case facts[:osfamily]
      when 'Debian'
        let (:platform_params) do
          { :qdr_package_name  => 'qdrouterd',
            :service_name      => 'qdrouterd',
            :sasl_package_list => ['sasl2-bin'],
            :service_home      => '/var/lib/qdrouterd'}
        end
      when 'RedHat'
        let (:platform_params) do
          { :qdr_package_name  => 'qpid-dispatch-router',
            :service_name      => 'qdrouterd',
            :sasl_package_list => ['cyrus-sasl-lib','cyrus-sasl-plain'],
            :service_home      => '/var/lib/qdrouterd'}
        end
      end

      it_behaves_like 'qdr'

    end

  end

end
