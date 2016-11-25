# hhvm installation
class hhvm {
  apt::source { 'hhvm':
    location => 'http://dl.hhvm.com/ubuntu',
    repos    => 'main',
    include  => {
      'src' => false,
      'deb' => true,
    },
    key      => {
      'id'     => '36AEF64D0207E7EEE352D4875A16E7281BE7A449',
    },
    notify   => Exec[ 'apt_update' ]
  }

  package { 'hhvm':
    ensure => 'present',
    notify => Exec[ 'update-rc.d hhvm defaults' ],
  }

  service { 'hhvm':
    ensure => 'running',
  }

  file { '/etc/hhvm/server.ini':
    source => 'puppet:///modules/hhvm/server.ini',
    owner  => 'root',
    group  => 'root',
    mode   => '0664',
    notify => Service['hhvm'],
  }

  file { '/etc/rsyslog.d/20-hhvm.conf':
    ensure  => 'present',
    source  => 'puppet:///modules/hhvm/hhvm.rsyslog.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => Service['rsyslog'],
  }

  file { '/etc/logrotate.d/hhvm':
    content => template('hhvm/hhvm.logrotate.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    before  => Package['hhvm'],
  }

  file { '/var/log/hhvm':
    ensure => directory,
    owner  => 'syslog',
    group  => $group,
    mode   => '0775',
    before => Service['hhvm'],
  }

  exec { 'update-rc.d hhvm defaults':
    refreshonly => true,
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:',
  }
}
