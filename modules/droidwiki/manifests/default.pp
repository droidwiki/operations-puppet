# Default things to do for all servers.
class droidwiki::default () {
  file { '/etc/hosts':
    ensure  => file,
    content => template('droidwiki/hosts.default.erb'),
  }

  include droidwiki::ipv6
  include firewall
  include git

  resources { 'firewall':
    purge => false,
  }

  firewallchain { 'INPUT:filter:IPv4':
    ensure => present,
    purge  => true,
  }

  firewallchain { 'OUTPUT:filter:IPv4':
    ensure => present,
    purge  => true,
  }

  firewallchain { 'FORWARD:filter:IPv4':
    ensure => present,
    purge  => true,
    ignore => [
      'docker',
      'DOCKER',
      'br-'
    ],
  }

  firewallchain { 'INPUT:filter:IPv6':
    ensure => present,
    purge  => true,
  }

  firewallchain { 'OUTPUT:filter:IPv6':
    ensure => present,
    purge  => true,
  }

  firewallchain { 'FORWARD:filter:IPv6':
    ensure => present,
    purge  => true,
  }

  Firewall {
    before  => Class['fw::post'],
    require => Class['fw::pre'],
  }

  class { ['fw::pre', 'fw::post']: }

  include ssh

  firewall { '300 accept outgoing https traffic':
    proto  => 'tcp',
    dport  => '443',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '300 accept outgoing https traffic IPv6':
    proto    => 'tcp',
    dport    => '443',
    chain    => 'OUTPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '302 accept outgoing http traffic':
    proto  => 'tcp',
    dport  => '80',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '302 accept outgoing http traffic IPv6':
    proto    => 'tcp',
    dport    => '80',
    chain    => 'OUTPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }

 firewall { '900 accept outgoing tcp requests to DOCKER':
    chain   => 'OUTPUT',
    proto   => 'all',
    jump    => 'DOCKER',
  }

  firewall { '901 accept incoming udp docker gateway requests':
    chain   => 'INPUT',
    action  => 'accept',
    proto   => 'tcp',
    iniface => 'docker_gwbridge',
    # monit, infamous-stats, infamous-rcon, concourse, mariadb, memcached, redis, vault
    dport   => [2812, 7010, 7020, 8010, 8020, 8081, 3306, 9091, 9323, 8200],
  }
}
