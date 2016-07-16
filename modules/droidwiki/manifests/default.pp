# Default things to do for all servers.
# Create a default user (florian) and run apt-get update
class droidwiki::default {
  user { 'florian':
    ensure     => present,
    name       => 'florian',
    shell      => '/bin/bash',
    home       => '/home/florian',
    system     => true,
    managehome => true,
  }

  # exec { 'apt-update':
  #   command => '/usr/bin/apt-get update'
  # }

  # Exec['apt-update'] -> Package <| |>

  file { '/etc/hosts':
    ensure  => file,
    content => template('droidwiki/hosts.default.erb'),
  }

  # ensure, that rc.local doesn't contain /etc/iptables.local call
  include droidwiki::rclocal
  file { '/etc/iptables.local':
    ensure => 'absent',
  }

  class { 'firewall': }

  resources { 'firewall':
    purge   => true
  }

  Firewall {
    before  => Class['fw::post'],
    require => Class['fw::pre'],
  }

  class { ['fw::pre', 'fw::post']: }

  package { 'python-all-dev':
    ensure => present,
  }

  file { '/usr/local/bin/pip-python':
    ensure => link,
    target => '/usr/local/bin/pip',
  }
}
