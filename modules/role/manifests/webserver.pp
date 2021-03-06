# Generic class for a webserver installation
# currently only handles the firewall rules
class role::webserver {
  firewall { '304 accept incoming http traffic':
    proto  => 'tcp',
    dport  => '80',
    action => 'accept',
  }

  firewall { '304 accept incoming http traffic IPv6':
    proto    => 'tcp',
    dport    => '80',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '305 accept incoming https traffic':
    proto  => 'tcp',
    dport  => '443',
    action => 'accept',
  }

  firewall { '305 accept incoming https traffic IPv6':
    proto    => 'tcp',
    dport    => '443',
    action   => 'accept',
    provider => 'ip6tables',
  }

  file { '/data/www':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0775',
  }
}
