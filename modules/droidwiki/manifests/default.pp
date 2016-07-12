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

  exec { 'apt-update':
    command => '/usr/bin/apt-get update'
  }

  Exec['apt-update'] -> Package <| |>

  file { '/etc/hosts':
    ensure  => file,
    content => template('droidwiki/hosts.default.erb'),
  }
}
