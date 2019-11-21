# Manages the dockerized Concourse
class role::concourse {
  class { 'docker::compose':
    ensure  => present,
    version => '1.24.0',
  }

  file { '/data/concourse':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }

  file { '/data/concourse/docker-compose.yml':
    ensure  => present,
    content => template('role/concourse/docker-compose.yml.erb'),
  }
}
