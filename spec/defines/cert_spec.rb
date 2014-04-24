require 'spec_helper'

describe 'certtool::cert', :type => :define do
  let(:pre_condition) do
    'include certtool'
  end

  let(:title) { 'rspec-cert' }

  describe 'os-dependent items' do
    context 'on Debian based systems' do
      let(:facts) do
        {
          :kernel   => 'Linux',
          :osfamily => 'Debian',
        }
      end
      it { should contain_class("certtool") }
      it { should contain_class("certtool::params") }

      it { should contain_file('/etc/ssl/certs').with(
        :ensure => 'directory'
      ) }

      it { should contain_file('/etc/ssl/private').with(
        :ensure => 'directory'
      ) }
    end

    context 'on RedHat based systems' do
      let(:facts) do
        {
          :kernel   => 'Linux',
          :osfamily => 'RedHat',
        }
      end
      it { should contain_class("certtool") }
      it { should contain_class("certtool::params") }

      it { should contain_file('/etc/pki/tls/certs').with(
        :ensure => 'directory'
      ) }

      it { should contain_file('/etc/pki/tls/private').with(
        :ensure => 'directory'
      ) }
    end
  end
end
