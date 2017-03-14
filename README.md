# Certtool Module for puppet

**Manages SSL certificates**

This module is used to create SSL certificates using certtool. This
includes CA certificates and self-signed certificates.

## Simple usage

    include certtool

    $caname = "TestCA"
    Certtool::Cert {
      organization    => "Test Organization",
      unit            => "IT",
      locality        => "Somecity",
      state           => "Somestate",
      country         => "US",
      caname          => $caname,
      expiration_days => 3650
    }

    certtool::cert { $caname:
      is_ca => true
    }

    certtool::cert { "www.puppet-certtool.test": 
      usage => [ "tls_www_server" ]
    }

    certtool::cert { "mail.puppet-certtool.test": }

## Classes

### certtool

The top-level class, to install the certtool package.

## Definitions

### certtool::cert

Create a SSL certificate.

## Contributing

Please report bugs and feature request using [GitHub issue
tracker](https://github.com/IntroSec/puppet-certtool/issues).