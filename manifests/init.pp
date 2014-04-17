# == Class: certtool
#
# This class installs the certtool program, used to manage ssl certificates
#
# === Parameters
#
# [*package*]
#   Name of the package containing certtool. Default depends on the distribution
#   being used.
#
# [*ensure*]
#   Ensure parameter for the package resource. Default "present".
#
# === Actions:
# - Install the package providing certtool
#
# === Requires
#
# === Author
#
# Michael Gruener <michael.gruener@chaosmoon.net>
#
# === Copyright
#
# Copyright 2014 Michael Gruener, unless otherwise noted.
#
class certtool (
  $package = $certtool::params::package,
  $ensure = present,
) inherits certtool::params {
  package { $package:
    ensure => $ensure,
  }
}
