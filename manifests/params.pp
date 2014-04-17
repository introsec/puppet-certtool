class certtool::params {
  if $::kernel != "Linux" {
    fail("${module_name} is only supported on Linux")
  }

  case $::operatingsystem {
    /^Debian|^Ubuntu/: { $package = 'gnutls-bin' }
    /^Fedora|^RedHat|^CentOS/: { $package = 'gnutls-utils' }
    default: { fail("${module_name} is not supported on ${::operatingsystem}") }
  }
}
