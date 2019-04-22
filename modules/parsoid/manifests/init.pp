# Installs and configures parsoid
class parsoid {
  apt::source { 'wikimedia':
    comment  => 'The official Wikimedia apt repository',
    location => 'https://releases.wikimedia.org/debian',
    release  => 'jessie-mediawiki',
    repos    => 'main',
    key      => {
      'id'     => 'A6FD76E2A61C5566D196D2C090E9F83F22250DD7',
      'server' => 'keys.gnupg.net',
    },
    include  => {
      'src' => false,
      'deb' => true,
    },
  }

  package { 'parsoid':
    ensure => 'installed'
  }

  service { 'parsoid':
    ensure => 'running',
    enable => 'true',
  }

  file { '/etc/mediawiki/parsoid/config.yaml':
    source => 'puppet:///modules/parsoid/config.yaml',
    notify => Service['parsoid']
  }
}
