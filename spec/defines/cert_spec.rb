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

  describe 'os-independent items' do
    let :facts do
      {
        :kernel   => 'Linux',
        :osfamily => 'RedHat',
      }
    end
    let :default_params do
      {
        :certpath   => '/rspec/certs',
        :keypath    => '/rspec/private',
        :pubkeypath => '/rspec/public'
      }
    end
    describe "basic requirements" do
      let :params do default_params end
      it { should contain_class("certtool") }
      it { should contain_class("certtool::params") }

      it { should contain_file("#{params[:certpath]}").with(
        :ensure => 'directory'
      ) }

      it { should contain_file("#{params[:keypath]}").with(
        :ensure => 'directory'
      ) }

      it { should contain_file("#{params[:pubkeypath]}").with(
        :ensure => 'directory'
      ) }

      it { should contain_file("#{params[:certpath]}/certtool-#{title}.cfg").with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root'
      ).that_requires("File[#{params[:certpath]}]") }

      it { should contain_file("#{params[:keypath]}/#{title}.key").with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0600'
      ) }

      it { should contain_exec("certtool-key-#{title}").with(
        :creates => "#{params[:keypath]}/#{title}.key",
        :command => /.*certtool.*--generate-privkey/
      ).that_requires("File[#{params[:keypath]}]") }
    end
  end
end
