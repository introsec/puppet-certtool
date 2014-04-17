# == Define: certtool::cert
#
# Manages a ssl certificate and its private / public key. Most parameters
# correspond to their equivalent in the configuration file used by certtool.
#
# === Parameters
#
# [*certpath*]
#   The path where the resulting certificate file should be placed. Default
#   depends on the distribution being used.
#
# [*keypath*]
#   The path where the private key of the certificate should be placed.
#   Default depends on the distribution being used.
#
# [*pubkeypath*]
#   The path where the public key of the certificate should be placed. Only
#   used if $extract_pubkey is true. Default depends on the distribution being
#   used.
#
# [*keybits*]
#   Number of bits used to create the private key. Default 2048.
#
# [*organization*]
#   The organization (O) of the certificate. Optional
#   but should be provided the create a working certificate.
#
# [*unit*]
#   The organizational unit (OU) of the certificate. Optional
#   but should be provided the create a working certificate.
#
# [*locality*]
#   The locality (L) of the certificate. Optional
#   but should be provided the create a working certificate.
#
# [*state*]
#   The state (ST) of the certificate. Optional
#   but should be provided the create a working certificate.
#
# [*country*]
#   The country (C) of the certificate. Optional
#   but should be provided the create a working certificate.
#
# [*common_name*]
#   The common name (CN) of the certificate. Normally the FQDN of system.
#   Optional but should be provided the create a working certificate.
#
# [*serial*]
#   The serial number of the certificate. Default is a random number.
#
# [*expiration_days*]
#   How long (in days) the certificate should be valid. Default 365.
#
# [*uris*]
#   Array of URIs using this certificate. Optional.
#
# [*dns_names*]
#   Array of alternate names (Subject alternate name) for the certificate.
#   Optional.
#
# [*ip*]
#   Array of IP adresses using this certificate. Optional.
#
# [*email*]
#   E-Mail address of the person which this certificate belongs to. Useful
#   in client certificates.
#
# [*is_ca*]
#   Set this to true if you want to create a CA certificate. Default false.
#
# [*caname*]
#   The name of the certtool::cert resource of the CA certificate that should
#   sign this certificate. Only used if this is a non-CA non-self-signed
#   certificate.
#
# [*usage*]
#   Array of usage types for this certificate, examples are
#   ['tls_www_server', 'signing_key']. See the certtool manpage for more
#   examples.
#
# [*use_request_extensions*]
#   If the extensions requested in the CSR should be included in the resulting
#   certificate.
#
# [*crl_dist_points*]
#   Array of URLs that have CRLs (certificate revocation lists). Used in CA
#   certificates.
#
# [*challenge_password*]
#   Challenge password used in certificate requests
#
# [*password*]
#   Password when encrypting a private key
#
# [*crl_number*]
#
# [*pkcs12_key_name*]
#
# [*extract_pubkey*]
#   Creates a separate file containing the public key if set to true. Default
#   false.
#
# [*combine_keycert*]
#   If set to true, the private key of the certificate will be included
#   in the resulting certificate file.
#
# [*self_signed*]
#   If the to true the resulting certificate will be self-signed. CA certifcates
#   (if $is_ca = true) are always self-signed. Default false.
#
# === Author
#
# Michael Gruener <michael.gruener@chaosmoon.net>
#
# === Copyright
#
# Copyright 2014 Michael Gruener, unless otherwise noted.
#
define certtool::cert (
  $certpath = $certtool::params::certpath,
  $keypath = $certtool::params::keypath,
  $pubkeypath = $certtool::params::pubkeypath,
  $keybits = 2048,
  $organization = undef,
  $unit = undef,
  $locality = undef,
  $state = undef,
  $country = undef,
  $common_name = $title,
  $serial = undef,
  $expiration_days = 365,
  $uris = undef,
  $dns_names = undef,
  $ip = undef,
  $email = undef,
  $is_ca = false,
  $caname = $title,
  $usage = undef,
  $use_request_extensions = undef,
  $crl_dist_points = undef,
  $challenge_password = undef,
  $password = undef,
  $crl_number = undef,
  $pkcs12_key_name = undef,
  $extract_pubkey = false,
  $combine_keycert = false,
  $self_signed = false,
) {
  if !defined(Class[$module_name]) {
    fail("Class ${module_name} not defined, please include it in your manifest.")
  }

  $keyfile = "${keypath}/${title}.key"
  $pubkeyfile = "${pubkeypath}/${title}-pub.key"
  $certfile = "${certpath}/${title}.crt"
  $requestfile = "${certpath}/${title}.csr"
  $cacertfile = "${certpath}/${caname}.crt"
  $cakeyfile = "${keypath}/${caname}.key"
  $template = "${certpath}/certtool-${title}.cfg"

  ensure_resource ( 'file' , [$certpath, $keypath], { ensure  => directory, })

  file { $template:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0640',
    content => template("${module_name}/certtool.cfg.erb"),
    require => File[$certpath]
  }

  file { $keyfile:
    ensure  => present,
    mode    => '0600',
    owner   => root,
    group   => root,
    require => Exec["certtool-key-${title}"]
  }

  exec { "certtool-key-${title}":
    creates => $keyfile,
    command => "certtool --generate-privkey \
                --outfile ${keyfile} \
                --bits ${keybits}",
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    require => File[$keypath]
  }

  if $extract_pubkey {
    exec { "certtool-pubkey-${title}":
      command => "certtool --load-privkey ${keyfile} --pubkey-info \
                  --outfile ${pubkeyfile}",
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
      creates => $pubkeyfile,
      require => Exec["certtool-key-${title}"]
    }
  }

  if $is_ca == true {
    exec { "certtool-ca-${title}":
      creates => $certfile,
      command => "certtool --generate-self-signed --template ${template} \
                  --load-privkey ${keyfile} \
                  --outfile ${certfile}",
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
      require => [File[$template], File[$keyfile]]
    }
  }
  else {
    if $self_signed == true {
      exec { "certtool-cert-${title}":
        creates => $certfile,
        command => "certtool --generate-self-signed --template ${template} \
                    --load-privkey ${keyfile} \
                    --outfile ${certfile}",
        path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        require => [File[$template], File[$keyfile]]
      }
    } else {
      exec { "certtool-csr-${title}":
        creates => $requestfile,
        command => "certtool --generate-request --template ${template} \
                    --load-privkey ${keyfile} \
                    --outfile ${requestfile}",
        path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        require => [File[$template], File[$keyfile]]
      }

      exec { "certtool-cert-${title}":
        creates => $certfile,
        command => "certtool --generate-certificate --template ${template} \
                    --load-request ${requestfile} \
                    --outfile ${certfile} \
                    --load-ca-certificate ${cacertfile} \
                    --load-ca-privkey ${cakeyfile}",
        path    => '/bin:/usr/bin:/sbin:/usr/sbin',
        require => [Exec["certtool-csr-${title}"], Certtool::Cert[$caname]]
      }
    }

    if $combine_keycert {
      Exec["certtool-cert-${title}"] ~> Exec["combine-key-cert-${title}"]

      exec { "combine-key-cert-${title}":
        command     => "cat ${keyfile} >> ${certfile}",
        path        => '/bin:/usr/bin:/sbin:/usr/sbin',
        refreshonly => true
      }
    }
  }
}
