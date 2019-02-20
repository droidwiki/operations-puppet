# Post run class for iptables configuration
class fw::post {
  firewall { '993 log dropped input chain':
    chain      => 'INPUT',
    jump       => 'LOG',
    log_level  => '6',
    log_prefix => '[IPTABLES INPUT] dropped ',
    proto      => 'all',
    before     => undef,
  }

  firewall { '993 log dropped input chain IPv6':
    chain      => 'INPUT',
    jump       => 'LOG',
    log_level  => '6',
    log_prefix => '[IPTABLES INPUT] dropped ',
    proto      => 'all',
    before     => undef,
    provider   => 'ip6tables',
  }

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

  firewall { '997 drop all input':
    proto  => 'all',
    action => 'drop',
    before => undef,
  }

  firewall { '997 drop all input IPv6':
    proto    => 'all',
    action   => 'drop',
    before   => undef,
    provider => 'ip6tables',
  }

  firewall { '998 drop all forward':
    proto  => 'all',
    chain  => 'FORWARD',
    action => 'drop',
    before => undef,
  }

  firewall { '998 drop all forward IPv6':
    proto    => 'all',
    chain    => 'FORWARD',
    action   => 'drop',
    before   => undef,
    provider => 'ip6tables',
  }

  firewall { '999 drop all output':
    proto  => 'all',
    chain  => 'OUTPUT',
    action => 'drop',
    before => undef,
  }

  firewall { '999 drop all output IPv6':
    proto    => 'all',
    chain    => 'OUTPUT',
    action   => 'drop',
    before   => undef,
    provider => 'ip6tables',
  }
}
