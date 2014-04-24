# Private class: certtool::params
#
# Module defaults for various operating systems
#
class certtool::params {
  if $::kernel != 'Linux' {
    fail("${module_name} is only supported on Linux")
  }

  case $::osfamily {
    'Debian': {
        $package = 'gnutls-bin'
        $certpath = '/etc/ssl/certs'
        $keypath = '/etc/ssl/private'
        $pubkeypath = '/etc/ssl/private'
      }
    'RedHat': {
        $package = 'gnutls-utils'
        $certpath = '/etc/pki/tls/certs'
        $keypath = '/etc/pki/tls/private'
        $pubkeypath = '/etc/pki/tls/private'
      }
    default: { fail("${module_name} is not supported on ${::operatingsystem}") }
  }
}
