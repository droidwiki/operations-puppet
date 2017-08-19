# Installs and configures the cxserver
class cxserver {
  service { 'cxserver':
    ensure  => 'running',
    enable  => true,
    require => Vcsrepo['/data/mediawiki/services/cxserver'],
  }

  vcsrepo { '/data/mediawiki/services/cxserver':
    ensure   => 'present',
    owner    => 'www-data',
    group    => 'www-data',
    provider => git,
    require  => [ Package['git'] ],
    source   => 'https://gerrit.wikimedia.org/r/p/mediawiki/services/cxserver',
    revision => 'master',
    notify   => Exec['cxserver npm install']
  }

  exec { 'cxserver npm install':
    command     => 'npm install',
    cwd         => '/data/mediawiki/services/cxerver',
    refreshonly => true,
    path        => [ '/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin' ],
    require     => Class['nodejs'],
    notify      => Service['cxserver'],
  }

  package { [ 'dictd', 'dict-freedict-eng-deu' ]:
    ensure => 'installed',
  }

  file { '/data/mediawiki/services/cxserver/config.yaml':
    ensure  => 'file',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    content => template('cxserver/config.yaml.erb'),
    notify  => Service['cxserver'],
  }

  file { '/etc/init/cxserver.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/cxserver/cxserver.service',
    notify => Service['cxserver'],
  }
}
