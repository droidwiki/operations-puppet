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

  vcsrepo { '/data/concourse':
    ensure   => 'latest',
    provider => git,
    require  => [ Package['git'] ],
    source   => 'https://github.com/concourse/concourse.git',
    revision => 'master',
  }

  file { '/data/concourse/docker-compose-droidwiki.yml':
    ensure  => present,
    content => template('role/concourse/docker-compose.yml.erb'),
  }
}
