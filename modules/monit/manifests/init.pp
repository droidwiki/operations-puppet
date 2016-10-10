# Manages monit
class monit(
  $mail_pass  = undef,
  $admin_pass = undef,
) {
  file { '/etc/default/monit':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    alias   => 'monit',
    source  => 'puppet:///modules/monit/monit.default',
    notify  => Service['monit'],
    require => Package['monit'],
  }

  file { '/etc/monit/conf.d':
    ensure  => directory,
    force   => true,
    purge   => true,
    recurse => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    alias   => 'conf.d',
    require => Package['monit'],
  }

  file { '/etc/monit/monitrc':
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    alias   => 'monitrc',
    content => template('monit/monitrc.erb'),
    notify  => Service['monit'],
    require => Package['monit'],
  }

  package { 'monit':
    ensure => present,
  }

  service { 'monit':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => false,
    require    => [
      File['monit'],
      File['monitrc'],
      Package['monit']
    ],
  }
}
