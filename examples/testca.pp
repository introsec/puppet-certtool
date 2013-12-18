class testca {
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
}
