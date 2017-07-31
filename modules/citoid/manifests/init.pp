# Manages the citoid service
class citoid {
  vcsrepo { '/data/mediawiki/services/citoid':
    ensure   => 'latest',
    owner    => 'www-data',
    group    => 'www-data',
    provider => git,
    require  => [ Package['git'] ],
    source   => 'https://gerrit.wikimedia.org/r/mediawiki/services/citoid',
    revision => 'master',
    notify   => [ Service['citoid'], Exec['update-citoid-node_modules'] ],
  }

  exec { 'update-citoid-node_modules':
    cwd         => '/data/mediawiki/services/citoid',
    command     => '/usr/bin/npm update',
    user        => 'www-data',
    group       => 'www-data',
    refreshonly => true,
  }

  file { '/etc/mediawiki/citoid.yaml':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/citoid/citoid.yaml',
    notify => Service['citoid'],
  }

  file { '/etc/init/citoid.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/citoid/citoid.init.conf',
    notify => Service['citoid'],
  }

  service { 'citoid':
    ensure  => 'running',
    enable  => true,
    require => Vcsrepo['/data/mediawiki/services/citoid'],
  }
}
