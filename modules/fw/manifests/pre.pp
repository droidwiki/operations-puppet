# Default firewall rules for all servers
class fw::pre {
  Firewall {
    require => undef,
  }

  firewall { '000 accept all icmp':
    proto  => 'icmp',
    action => 'accept',
  }

  firewall { '000 accept all icmpv6 IPv6':
    proto    => 'ipv6-icmp',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '000 accept all outgoing icmpv6 IPv6':
    proto    => 'ipv6-icmp',
    chain    => 'OUTPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }

  firewall { '001 accept all to lo interface IPv6':
    proto    => 'all',
    iniface  => 'lo',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '002 accept related established rules':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }

  firewall { '002 accept related established rules IPv6':
    proto    => 'all',
    state    => ['RELATED', 'ESTABLISHED'],
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '003 accept related established rules':
    proto  => 'all',
    chain  => 'OUTPUT',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }

  firewall { '003 accept related established rules IPv6':
    proto    => 'all',
    chain    => 'OUTPUT',
    state    => ['RELATED', 'ESTABLISHED'],
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '101 allow incoming ssh traffic':
    dport  => '22',
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '101 allow incoming ssh traffic IPv6':
    dport    => '22',
    proto    => 'tcp',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '102 allow outgoing ssh traffic':
    dport  => '22',
    proto  => 'tcp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '102 allow outgoing ssh traffic IPv6':
    dport    => '22',
    proto    => 'tcp',
    chain    => 'OUTPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '105 allow outgoing dns requests':
    dport  => '53',
    proto  => 'udp',
    chain  => 'OUTPUT',
    state  => ['NEW', 'ESTABLISHED'],
    action => 'accept',
  }

  firewall { '105 allow outgoing dns requests IPv6':
    dport    => '53',
    proto    => 'udp',
    chain    => 'OUTPUT',
    state    => ['NEW', 'ESTABLISHED'],
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '106 allow outgoing dns requests':
    dport  => '53',
    proto  => 'tcp',
    chain  => 'OUTPUT',
    state  => ['NEW', 'ESTABLISHED'],
    action => 'accept',
  }

  firewall { '106 allow outgoing dns requests IPv6':
    dport    => '53',
    proto    => 'tcp',
    chain    => 'OUTPUT',
    state    => ['NEW', 'ESTABLISHED'],
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '109 allow outgoing ntp traffic':
    dport  => '123',
    proto  => 'udp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '109 allow outgoing ntp traffic IPv6':
    dport    => '123',
    proto    => 'udp',
    chain    => 'OUTPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '112 allow outgoing traffic for HKP keyserver proto':
    chain  => 'OUTPUT',
    proto  => 'tcp',
    dport  => '11371',
    action => 'accept',
  }

  firewall { '112 allow outgoing traffic for HKP keyserver proto IPv6':
    chain    => 'OUTPUT',
    proto    => 'tcp',
    dport    => '11371',
    action   => 'accept',
    provider => 'ip6tables',
  }

  # dwnet network, trusted source and destination ips
  $trustedhosts = [
    # VLAN
    '172.16.0.0/12',
  ]

  $trustedhosts.each |Integer $index, String $ipaddress| {
    $inputcount = 114 + $index
    $outputcount = $inputcount + 1
    firewall { "${outputcount} allow outgoing traffic to ${ipaddress}":
      proto       => 'all',
      chain       => 'OUTPUT',
      destination => $ipaddress,
      action      => 'accept',
    }

    firewall { "${inputcount} allow incoming traffic from ${ipaddress}":
      proto  => 'all',
      source => $ipaddress,
      action => 'accept',
    }
  }
}
