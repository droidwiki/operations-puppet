# Wrapper for managing puppetboard
class role::puppetboard {
  class { 'puppetboard':
    manage_virtualenv => 'latest',
    puppetdb_port     => '8083',
    enable_query      => false,
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
