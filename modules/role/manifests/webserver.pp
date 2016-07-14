# Generic class for a webserver installation
# currently only handles the firewall rules
class role::webserver {
  firewall { '300 accept incoming http traffic':
    proto  => 'tcp',
    dport  => '80',
    action => 'accept',
  }

  firewall { '301 accept outgoing http traffic':
    proto  => 'tcp',
    dport  => '80',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '302 accept outgoing http traffic':
    proto  => 'tcp',
    sport  => '80',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '303 accept incoming https traffic':
    proto  => 'tcp',
    dport  => '443',
    action => 'accept',
  }

  firewall { '304 accept outgoing https traffic':
    proto  => 'tcp',
    dport  => '443',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '305 accept outgoing https traffic':
    proto  => 'tcp',
    sport  => '443',
    chain  => 'OUTPUT',
    action => 'accept',
  }
}
