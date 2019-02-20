# Manages the dockerized Concourse
class role::concourse {
  include 'docker'
  class {'docker::compose':
    ensure  => present,
    version => '1.23.2',
  }

  vcsrepo { '/data/concourse':
    ensure   => 'latest',
    provider => git,
    require  => [ Package['git'] ],
    source   => 'https://github.com/concourse/concourse.git',
    revision => 'master',
    notify   => Docker_compose['concourse'],
  }

  file { '/data/concourse/docker-compose-droidwiki.yml':
    ensure  => present,
    content => template('role/concourse/docker-compose.yml.erb'),
  }

  docker_compose { 'concourse':
    compose_files => ['/data/concourse/docker-compose-droidwiki.yml'],
    ensure        => present,
  }
}
