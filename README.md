# Certtool Module for puppet

[![Build Status](https://travis-ci.org/mgruener/puppet-certtool.png?branch=master)](https://travis-ci.org/mgruener/puppet-certtool)

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
tracker](https://github.com/mgruener/puppet-certtool/issues).

## License

    Copyright (C) 2014 Michael Gruener

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
