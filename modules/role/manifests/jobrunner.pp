# Class to install and manage jobrunner and jobchron services.
# Both services makes sure, that the mediawiki jobqueue is
# continuously executed.
class role::jobrunner {
  service { 'jobrunner':
    ensure  => 'running',
    enable  => true,
    require => Vcsrepo['/data/mediawiki/services/jobrunner'],
  }

  service { 'jobchron':
    ensure  => 'running',
    enable  => true,
    require => Vcsrepo['/data/mediawiki/services/jobrunner'],
  }

  vcsrepo { '/data/mediawiki/services/jobrunner':
    ensure   => 'latest',
    owner    => 'florian',
    group    => 'florian',
    provider => git,
    require  => [ Package['git'] ],
    source   => 'https://gerrit.wikimedia.org/r/mediawiki/services/jobrunner',
    revision => 'master',
    notify   => Service['jobrunner', 'jobchron'],
  }

  file { '/etc/mediawiki/jobrunner.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/role/jobrunner.conf',
    notify => Service['jobrunner', 'jobchron'],
  }

  file { '/etc/default/jobrunner':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/role/jobrunner.default',
    notify => Service['jobrunner'],
  }

  file { '/etc/init/jobrunner.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/role/jobrunner.init.conf',
    notify => Service['jobrunner'],
  }

  file { '/etc/init/jobchron.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/role/jobchron.init.conf',
    notify => Service['jobchron'],
  }
}
