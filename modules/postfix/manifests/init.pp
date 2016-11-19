# Handles the installation and configuration of postfix
class postfix(
  $certpath = '/etc/postfix/mailserver.crt',
  $keypath = '/etc/postfix/mailserver.key',
  $my_hostname = undef,
  $vmaildbpass = undef,
  $vmaildbuser = 'vmail',
  $vmaildbhost = 'eclair.dwnet',
  $vmaildbname = 'vmail',
) {
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

  # FIXME: Remove this after some days (e.g. after the 20th November), so
  # there's enough time, that the file is removed.
  file { '/etc/postfix/go2tech.de.crt':
    ensure => absent,
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
