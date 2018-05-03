# Wrapper for managing puppetboard
class role::puppetboard {
  class { 'puppetboard':
    manage_virtualenv => true,
    puppetdb_port     => 8083,
    enable_query      => false,
  }

  package { 'uwsgi':
    ensure => present,
  }

  service { 'uwsgi':
    ensure  => running,
    require => Package['uwsgi'],
  }

  file { '/etc/uwsgi/apps-available/puppetboard.ini':
    ensure  => present,
    source  => 'puppet:///modules/role/puppetboard/puppetboard.ini',
    notify  => Service['uwsgi'],
  }

  package { 'flask':
    ensure   => present,
    provider => 'pip',
  }

  package { 'flask-wtf':
    ensure   => present,
    provider => 'pip',
  }

  package { 'pypuppetdb':
    ensure   => present,
    provider => 'pip',
  }
}
