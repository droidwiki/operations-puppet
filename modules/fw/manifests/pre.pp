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

  firewall { '100 allow incoming ssh traffic':
    sport  => '22',
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '100 allow incoming ssh traffic IPv6':
    sport    => '22',
    proto    => 'tcp',
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

  firewall { '103 allow outgoing ssh traffic':
    sport  => '22',
    proto  => 'tcp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '103 allow outgoing ssh traffic IPv6':
    sport    => '22',
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

  firewall { '107 allow outgoing ftp traffic':
    dport  => '20',
    proto  => 'tcp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '107 allow outgoing ftp traffic IPv6':
    dport    => '20',
    proto    => 'tcp',
    chain    => 'OUTPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '108 allow outgoing ftp traffic':
    dport  => '21',
    proto  => 'tcp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '108 allow outgoing ftp traffic IPv6':
    dport    => '21',
    proto    => 'tcp',
    chain    => 'OUTPUT',
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

  firewall { '110 allow outgoing localhost traffic':
    source => '127.0.0.1',
    action => 'accept',
  }

  firewall { '110 allow outgoing localhost traffic IPv6':
    source   => '::1',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '111 allow incoming localhost traffic':
    destination => '127.0.0.1',
    chain       => 'OUTPUT',
    action      => 'accept',
  }

  firewall { '111 allow incoming localhost traffic IPv6':
    destination => '::1',
    chain       => 'OUTPUT',
    action      => 'accept',
    provider    => 'ip6tables',
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

  firewall { '113 allow outgoing dhcp traffic':
    chain  => 'OUTPUT',
    proto  => 'udp',
    dport  => '67',
    action => 'accept',
  }

  firewall { '113 allow outgoing dhcp traffic IPv6':
    chain    => 'OUTPUT',
    proto    => 'udp',
    dport    => '67',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '114 allow outgoing dhcp traffic':
    chain  => 'OUTPUT',
    proto  => 'udp',
    dport  => '547',
    action => 'accept',
  }

  firewall { '114 allow outgoing dhcp traffic IPv6':
    chain    => 'OUTPUT',
    proto    => 'udp',
    dport    => '547',
    action   => 'accept',
    provider => 'ip6tables',
  }

  # dwnet network, trusted source and destination ips
  $trustedhosts = [
    # v22015112656329114@netcup, go2tech.de
    '188.68.49.74',
    # v22015052656325188@netcup, droidwiki.de
    '37.120.178.25',
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

  # dwnet network, trusted source and destination ips
  $trustedipv6hosts = [
    # v22015112656329114@netcup, go2tech.de
    '2a03:4000:6:d06b::1',
    # v22015052656325188@netcup, droidwiki.de
    '2a03:4000:6:80b1::1',
  ]

  $trustedipv6hosts.each |Integer $index, String $ipaddress| {
    $inputcount = 114 + $index
    $outputcount = $inputcount + 1
    firewall { "${outputcount} allow outgoing traffic to ${ipaddress} IPv6":
      proto       => 'all',
      chain       => 'OUTPUT',
      destination => $ipaddress,
      action      => 'accept',
      provider    => 'ip6tables',
    }

    firewall { "${inputcount} allow incoming traffic from ${ipaddress} IPv6":
      proto    => 'all',
      source   => $ipaddress,
      action   => 'accept',
      provider => 'ip6tables',
    }
  }
}
