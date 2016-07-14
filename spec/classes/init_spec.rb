require 'spec_helper'

describe 'qdr' do

  shared_examples 'qdr' do
  
    it 'contains the install class' do
      is_expected.to contain_class('qdr::install')
    end

    it 'contains the config class' do
      is_expected.to contain_class('qdr::config')
    end

    it 'contains the service class' do
      is_expected.to contain_class('qdr::service')
    end    
  
    it 'installs packages' do
      is_expected.to contain_package(platform_params[:qdr_package_name]).with({ :ensure => :installed })
      is_expected.to contain_package('cyrus-sasl-lib').with({ :ensure => :installed })
      is_expected.to contain_package('cyrus-sasl-plain').with({ :ensure => :installed }) 
    end

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
  end

#  context 'on Debian platforms' do
#
#    let :platform_params do
#      { :qdr_package_name => 'qdrouterd',
#        :sasl_package_list => [ 'sasl2-bin' ] }            
#    end
    
#    it_behaves_like 'qdr'
#  end

#  context 'on Ubuntu platforms' do

#    let :platform_params do
#      { :qdr_package_name  => 'qdrouterd',
#        :service_name      =>
#        :sasl_package_list => [ 'sasl2-bin' ] }      
#        :service_home      =>
#    end
    
#    it_behaves_like 'qdr'
#  end

  context 'on RedHat platforms' do

    let :platform_params do
      { :qdr_package_name  => 'qpid-dispatch-router',
        :service_name      => 'qdrouterd',
        :sasl_package_list => ['cyrus-sasl-lib','cyrus-sasl-plain'],
        :service_home      => '/var/lib/qdrouterd'}
    end
    
    it_behaves_like 'qdr'
  end
  
end
