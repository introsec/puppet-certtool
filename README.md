# Certtool Modul for puppet

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

Copyright (c) 2014 michael.gruener@chaosmoon.net All rights reserved.

    Redistribution and use in source and binary forms, with or without modification,
    are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this
      list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright notice, this
      list of conditions and the following disclaimer in the documentation and/or
      other materials provided with the distribution.

    * Neither the name Chaosmoon nor the names of its
      contributors may be used to endorse or promote products derived from
      this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
    ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
    ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
