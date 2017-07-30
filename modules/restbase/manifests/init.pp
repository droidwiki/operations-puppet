# This class handles the installation and configuration of
# restbase
class restbase (
  $with_cx = false,
) {
  service { 'restbase':
    ensure  => 'running',
    enable  => true,
    require => Vcsrepo['/data/mediawiki/services/restbase'],
  }

  vcsrepo { '/data/mediawiki/services/restbase':
    ensure   => 'latest',
    owner    => 'www-data',
    group    => 'www-data',
    provider => git,
    require  => [ Package['git'] ],
    source   => 'https://github.com/wikimedia/restbase.git',
    revision => 'master',
    notify   => Exec['restbase npm install']
  }

  exec { 'restbase npm install':
    command     => 'npm install',
    cwd         => '/data/mediawiki/services/restbase',
    refreshonly => true,
    path        => [ '/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin' ],
    require     => Class['nodejs'],
    notify      => Service['restbase'],
  }

  file { '/data/mediawiki/services/restbase/config.yaml':
    ensure  => 'present',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    content => template('restbase/config.yaml.erb'),
    notify  => Service['restbase'],
  }

  file { '/data/mediawiki/services/restbase/projects/droidwiki.yaml':
    ensure  => 'present',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    source  => 'puppet:///modules/restbase/droidwiki.yaml',
    notify  => Service['restbase'],
  }

  file { '/etc/init/restbase.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/restbase/restbase.service',
    notify => Service['restbase'],
  }
}
