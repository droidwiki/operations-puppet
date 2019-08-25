# Manages docker in swarm mode
class role::docker(
  $manager   = false,
  $worker_ip = Undef,
  $token     = Undef,
) {
  file { '/data/docker':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  class { 'docker':
    extra_parameters => ['-g /data/docker']
  }

  firewall { '900 accept outgoing requests to DOCKER':
    chain   => 'OUTPUT',
    proto   => 'all',
    jump    => 'DOCKER',
    require => Class['docker'],
  }

  if ($manager) {
    docker::swarm {'cluster_manager':
      init           => true,
      advertise_addr => '172.16.0.2',
      listen_addr    => '172.16.0.2',
    }
  }

  if ($worker_ip != Undef) {
    docker::swarm {'cluster_worker':
      join           => true,
      advertise_addr => $worker_ip,
      listen_addr    => $worker_ip,
      manager_ip     => '172.16.0.2',
      token          => $token,
    }
  }
}
