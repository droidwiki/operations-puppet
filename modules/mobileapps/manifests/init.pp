# This class handles the installation and configuration of
# restbase
class mobileapps {
  service { 'mobileapps':
    ensure  => 'running',
    enable  => true,
    require => Vcsrepo['/data/mediawiki/services/mobileapps'],
  }

  vcsrepo { '/data/mediawiki/services/mobileapps':
    ensure   => present,
    owner    => 'www-data',
    group    => 'www-data',
    provider => git,
    require  => [ Package['git'] ],
    source   => 'https://github.com/wikimedia/mediawiki-services-mobileapps.git',
    notify   => Exec['mobileapps npm install']
  }

  exec { 'mobileapps npm install':
    command     => 'npm install',
    cwd         => '/data/mediawiki/services/mobileapps',
    refreshonly => true,
    path        => [ '/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin' ],
    require     => Class['nodejs'],
    notify      => Service['mobileapps'],
  }

  file { '/data/mediawiki/services/mobileapps/config.yaml':
    ensure  => 'file',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',
    replace => true,
    content => template('mobileapps/config.yaml.erb'),
    notify  => Service['mobileapps'],
  }

  file { '/etc/systemd/system/mobileapps.service':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0664',
    source => 'puppet:///modules/mobileapps/mobileapps.service',
    notify => Service['mobileapps'],
  }
}
