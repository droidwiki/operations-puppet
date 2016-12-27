# Default things to do for all servers.
# Create a default user (florian) and run apt-get update
class droidwiki::default (
  $isNFSServer = false,
) {
  user { 'florian':
    ensure     => present,
    name       => 'florian',
    shell      => '/bin/bash',
    home       => '/home/florian',
    system     => true,
    managehome => true,
  }

  file { '/etc/hosts':
    ensure  => file,
    content => template('droidwiki/hosts.default.erb'),
  }

  include firewall
  include git

  resources { 'firewall':
    purge   => true
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

  class { 'rsyslog::client':
    server => 'eclair.dwnet',
    port   => '1514',
  }

  if ($isNFSServer == false) {
    # all droidwiki servers should have access to the nfs shareddata
    class { '::nfs':
      client_enabled => true,
    }
    Nfs::Client::Mount <<| |>>
  }
}
