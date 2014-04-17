class certtool (
  $package = $certtool::params::package,
  $ensure = present,
) inherits certtool::params {
  package { $package:
    ensure => $ensure,
  }
}
