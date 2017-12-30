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
    owner    => 'www-data',
    group    => 'www-data',
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

  file { '/etc/systemd/system/jobrunner.service':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/role/jobrunner.service',
    notify => Service['jobrunner'],
  }

  file { '/etc/systemd/system/jobchron.service':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/role/jobchron.service',
    notify => Service['jobchron'],
  }

  monit::service { 'mediawiki-jobrunner': }
  monit::service { 'mediawiki-jobchron': }
}
