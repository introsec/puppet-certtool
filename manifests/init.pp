class certtool {
  $certtool = $::operatingsystem ? {
    /^Debian|^Ubuntu/ => 'gnutls-bin',
    /^Fedora|^RedHat|^CentOS/ => 'gnutls-utils',
  }

  package { $certtool:
    ensure => present
  }
}
