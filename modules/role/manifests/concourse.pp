# Manages the dockerized Concourse
class role::concourse {
  file { '/data/docker':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  class { 'docker':
    extra_parameters => ['-g /data/docker']
  }

  class { 'docker::compose':
    ensure  => present,
    version => '1.23.2',
  }

  firewall { '900 accept outgoing requests to DOCKER':
    chain => 'OUTPUT',
    proto => 'all',
    jump  => 'DOCKER',
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
