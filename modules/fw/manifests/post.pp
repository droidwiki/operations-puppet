# Post run class for iptables configuration
class fw::post {
  firewall { '994 log dropped forward chain':
    chain      => 'FORWARD',
    jump       => 'LOG',
    log_level  => '6',
    log_prefix => '[IPTABLES FORWARD] dropped ',
    proto      => 'all',
    before     => undef,
  }

  firewall { '994 log dropped forward chain IPv6':
    chain      => 'FORWARD',
    jump       => 'LOG',
    log_level  => '6',
    log_prefix => '[IPTABLES FORWARD] dropped ',
    proto      => 'all',
    before     => undef,
    provider   => 'ip6tables',
  }

  firewall { '995 log dropped output chain':
    chain      => 'OUTPUT',
    jump       => 'LOG',
    log_level  => '6',
    log_prefix => '[IPTABLES OUTPUT] dropped ',
    proto      => 'all',
    before     => undef,
  }

  firewall { '995 log dropped output chain IPv6':
    chain      => 'OUTPUT',
    jump       => 'LOG',
    log_level  => '6',
    log_prefix => '[IPTABLES OUTPUT] dropped ',
    proto      => 'all',
    before     => undef,
    provider   => 'ip6tables',
  }

  firewall { '996 deny all other input requests':
    chain  => 'INPUT',
    action => 'drop',
    proto  => 'all',
    before => undef,
  }

  firewall { '996 deny all other input requests IPv6':
    chain    => 'INPUT',
    action   => 'drop',
    proto    => 'all',
    before   => undef,
    provider => 'ip6tables',
  }
}
