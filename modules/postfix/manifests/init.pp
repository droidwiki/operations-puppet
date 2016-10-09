# Handles the installation and configuration of postfix
class postfix(
  $certfilesource = undef,
  $certpath = '/etc/postfix/mailserver.crt',
  $keypath = '/etc/postfix/mailserver.key',
  $my_hostname = undef,
  $vmaildbpass = undef,
  $vmaildbuser = 'vmail',
  $vmaildbhost = '37.120.178.25',
  $vmaildbname = 'vmail',
) {
  validate_string($certfilesource)
  validate_string($my_hostname)
  validate_string($certpath)
  validate_string($keypath)
  validate_string($vmaildbuser)
  validate_string($vmaildbpass)
  validate_string($vmaildbhost)
  validate_string($vmaildbname)

  package { 'postfix':
    ensure => 'present',
  }

  service { 'postfix':
    ensure  => 'running',
    enable  => true,
    require => Package['postfix'],
  }

  file { $certpath:
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => $certfilesource,
    notify => Service['postfix'],
  }

  file { '/etc/postfix/main.cf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('postfix/main.cf.erb'),
    notify  => Service['postfix'],
  }

  file { '/etc/postfix/master.cf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('postfix/master.cf.erb'),
    notify  => Service['postfix'],
  }

  file { '/etc/postfix/sql':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0660',
  }

  file { '/etc/postfix/sql/aliases.cf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0660',
    content => template('postfix/sql/aliases.cf.erb'),
    notify  => Service['postfix'],
  }

  file { '/etc/postfix/sql/domains.cf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0660',
    content => template('postfix/sql/domains.cf.erb'),
    notify  => Service['postfix'],
  }

  file { '/etc/postfix/sql/maps.cf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0660',
    content => template('postfix/sql/maps.cf.erb'),
    notify  => Service['postfix'],
  }

  file { '/etc/postfix/sql/sender-login-maps.cf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0660',
    content => template('postfix/sql/sender-login-maps.cf.erb'),
    notify  => Service['postfix'],
  }

  file { '/etc/postfix/submission_header_cleanup':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0660',
    source => 'puppet:///modules/postfix/submission_header_cleanup',
    notify => Service['postfix'],
  }
}