# Installs and configures postsrsd
class postsrsd {
  package { 'postsrsd':
    ensure => 'present',
  }

  file { '/etc/postsrsd.secret':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0660',
    content => lookup( 'postsrsd::secret' ),
  }
}
