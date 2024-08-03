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
}
