# Default firewall rules for all servers
class fw::pre {
  Firewall {
    require => undef,
  }

  firewall { '000 accept all icmp':
    proto  => 'icmp',
    action => 'accept',
  }

  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }

  firewall { '002 accept related established rules':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }

  firewall { '003 accept related established rules':
    proto  => 'all',
    chain  => 'OUTPUT',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }

  firewall { '100 allow incoming ssh traffic':
    sport  => '22',
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '101 allow incoming ssh traffic':
    dport  => '22',
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '102 allow outgoing ssh traffic':
    dport  => '22',
    proto  => 'tcp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '103 allow outgoing ssh traffic':
    sport  => '22',
    proto  => 'tcp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '104 allow puppet communication':
    dport  => '8140',
    proto  => 'tcp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '105 allow outgoing dns requests':
    dport  => '53',
    proto  => 'udp',
    chain  => 'OUTPUT',
    state  => ['NEW', 'ESTABLISHED'],
    action => 'accept',
  }

  firewall { '106 allow outgoing dns requests':
    dport  => '53',
    proto  => 'tcp',
    chain  => 'OUTPUT',
    state  => ['NEW', 'ESTABLISHED'],
    action => 'accept',
  }

  firewall { '107 allow outgoing ftp traffic':
    dport  => '20',
    proto  => 'tcp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '108 allow outgoing ftp traffic':
    dport  => '21',
    proto  => 'tcp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '109 allow outgoing ntp traffic':
    dport  => '123',
    proto  => 'udp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '110 allow outgoing localhost traffic':
    source => '127.0.0.1',
    action => 'accept',
  }

  firewall { '111 allow incoming localhost traffic':
    destination => '127.0.0.1',
    chain       => 'OUTPUT',
    action      => 'accept',
  }

  firewall { '112 allow outgoing traffic for HKP keyserver proto':
    chain  => 'OUTPUT',
    proto  => 'tcp',
    dport  => '11371',
    action => 'accept',
  }

  # dwnet network, trusted source and destination ips
  $trustedHosts = [
    # v22015112656329114@netcup, go2tech.de
    '188.68.49.74',
    # v22015052656325188@netcup, droidwiki.de
    '37.120.178.25',
  ]

  $trustedHosts.each |Integer $index, String $ipAddress| {
    $inputCount = 111 + $index
    $outputCount = $inputCount + 1
    firewall { "${outputCount} allow outgoing traffic to ${ipAddress}":
      proto       => 'all',
      chain       => 'OUTPUT',
      destination => $ipAddress,
      action      => 'accept',
    }

    firewall { "${inputCount} allow incoming traffic from ${ipAddress}":
      proto  => 'all',
      source => $ipAddress,
      action => 'accept',
    }
  }
}
