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

    describe "extracting the pubkey" do
      let :params do
        default_params.merge(:extract_pubkey => true)
      end
      it { should contain_exec("certtool-pubkey-#{title}").with(
        :creates => "#{params[:pubkeypath]}/#{title}-pub.key",
        :command => /.*certtool\s*--load-privkey\s*#{params[:keypath]}\/#{title}.key\s*--pubkey-info\s*--outfile\s*#{params[:pubkeypath]}\/#{title}-pub.key/
      ).that_requires("Exec[certtool-key-#{title}]") }
    end

    describe "creating a CA certificate" do
      let :params do
        default_params.merge(:is_ca => true)
      end
      it { should contain_exec("certtool-ca-#{title}").with(
        :creates => "#{params[:certpath]}/#{title}.crt",
        :command => /.*certtool\s*--generate-self-signed\s*--template\s*#{params[:certpath]}\/certtool-#{title}.cfg\s*--load-privkey\s*#{params[:keypath]}\/#{title}.key\s*--outfile\s*#{params[:certpath]}\/#{title}.crt/
      ).that_requires("File[#{params[:certpath]}/certtool-#{title}.cfg]").that_requires("File[#{params[:keypath]}/#{title}.key]") }
    end

    describe "creating a self-signed certificate" do
      let :params do
        default_params.merge(:self_signed => true)
      end
      it { should contain_exec("certtool-cert-#{title}").with(
        :creates => "#{params[:certpath]}/#{title}.crt",
        :command => /.*certtool\s*--generate-self-signed\s*--template\s*#{params[:certpath]}\/certtool-#{title}.cfg\s*--load-privkey\s*#{params[:keypath]}\/#{title}.key\s*--outfile\s*#{params[:certpath]}\/#{title}.crt/
      ).that_requires("File[#{params[:certpath]}/certtool-#{title}.cfg]").that_requires("File[#{params[:keypath]}/#{title}.key]") }
    end
  end
end
