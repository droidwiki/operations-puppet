# Installs and manages bind
class role::dns() {
  firewall { '700 allow incoming dns requests':
    dport  => 53,
    proto  => 'udp',
    chain  => 'INPUT',
    action => 'accept',
  }

  firewall { '700 allow incoming dns requests IPv6':
    dport    => 53,
    proto    => 'udp',
    chain    => 'INPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '703 allow incoming dns requests':
    dport  => 53,
    proto  => 'tcp',
    chain  => 'INPUT',
    action => 'accept',
  }

  firewall { '703 allow incoming dns requests IPv6':
    dport    => 53,
    proto    => 'tcp',
    chain    => 'INPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }

  file { '/var/lib/bind/zones':
    ensure => 'directory',
    owner  => 'bind',
    group  => 'bind',
  }
}
