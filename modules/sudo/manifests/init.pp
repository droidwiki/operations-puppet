# Manages the sudo package and the sudoers file.
class sudo {

  $package = 'sudo'

  package { $package:
    ensure => installed,
  }

  file { '/etc/sudoers':
    ensure  => present,
    mode    => '0440',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/sudo/sudoers',
    require => Package[$package],
  }
}
