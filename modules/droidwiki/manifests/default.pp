# Default things to do for all servers.
class droidwiki::default (
  $isnfsserver = false,
) {
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

  file { '/usr/local/bin/pip-python':
    ensure => link,
    target => '/usr/local/bin/pip',
  }

  if ($isnfsserver == false) {
    # all droidwiki servers should have access to the nfs shareddata
    class { '::nfs':
      client_enabled => true,
    }
    Nfs::Client::Mount <<| |>>
  }

  include ssh
  include admin

  include monit
  monit::service { 'os_disk': }
  monit::service { 'data_disk': }

  firewall { '300 accept outgoing https traffic':
    proto  => 'tcp',
    sport  => '443',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '300 accept outgoing https traffic IPv6':
    proto    => 'tcp',
    sport    => '443',
    chain    => 'OUTPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '301 accept outgoing https traffic':
    proto  => 'tcp',
    dport  => '443',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '301 accept outgoing https traffic IPv6':
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

  firewall { '303 accept outgoing http traffic':
    proto  => 'tcp',
    sport  => '80',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '303 accept outgoing http traffic IPv6':
    proto    => 'tcp',
    sport    => '80',
    chain    => 'OUTPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }
}
