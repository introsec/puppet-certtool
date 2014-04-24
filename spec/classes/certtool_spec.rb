require 'spec_helper'

describe 'certtool', :type => :class do
  context 'on Debian OS' do
    let(:facts) do
      {
        :kernel   => 'Linux',
        :osfamily => 'Debian',
      }
    end

    it { should contain_class('certtool::params') }
    it { should contain_package('gnutls-bin').with(
      'ensure' => 'present'
      )
    }

    context 'with ensure => latest and package => gnutls-custom' do
      let(:params) do
        {
          :package => 'gnutls-custom',
          :ensure  => 'latest',
        }
      end
      it { should contain_package('gnutls-custom').with(
        'ensure' => 'latest'
        )
      }
    end
  end

  context 'on RedHat OS' do
    let(:facts) do
      {
        :kernel   => 'Linux',
        :osfamily => 'RedHat',
      }
    end

    it { should contain_class('certtool::params') }
    it { should contain_package('gnutls-utils').with(
      'ensure' => 'present'
      )
    }

    context 'with ensure => latest and package => gnutls-custom' do
      let(:params) do
        {
          :package => 'gnutls-custom',
          :ensure  => 'latest',
        }
      end
      it { should contain_package('gnutls-custom').with(
        'ensure' => 'latest'
        )
      }
    end
  end
end
