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
    extra_parameters => ['-g /data/docker --metrics-addr 0.0.0.0:9323 --experimental=true']
  }

  file { [ '/data/ha_volume', '/data/bricks', '/data/bricks/brick1', '/data/bricks/brick2' ]:
    ensure  => 'directory',
  }

  class { '::gluster':
    repo    => false,
    client  => false,
    pool    => 'production',
    volumes => {
      'ha_volume' => {
        replica => 2,
        bricks  => [
          'eclair.dwnet:/data/bricks/brick1/brick',
          'donut.dwnet:/data/bricks/brick1/brick',
          'eclair.dwnet:/data/bricks/brick2/brick',
          'donut.dwnet:/data/bricks/brick2/brick',
        ],
        options => [
          'server.allow-insecure: "on"',
          'nfs.disable: "true"',
        ],
      }
    }
  }

  gluster::mount { '/data/ha_volume':
    volume    => 'localhost:/ha_volume',
    transport => 'tcp',
    atboot    => true,
    dump      => 0,
    pass      => 0,
  }

  firewall { '900 accept outgoing tcp requests to DOCKER':
    chain   => 'OUTPUT',
    proto   => 'all',
    jump    => 'DOCKER',
    require => Class['docker'],
  }

  firewall { '901 accept incoming udp docker gateway requests':
    chain   => 'INPUT',
    action  => 'accept',
    proto   => 'tcp',
    iniface => 'docker_gwbridge',
    # monit, concourse, mariadb, memcached, redis, elasticsearch, prometheus, grafana, dockerd metrics
    dport   => [2812, 8081, 3306, 11211, 6379, 9200, 9090, 9091, 9323],
    require => Class['docker'],
  }

  firewall { '901 accept incoming docker gateway requests':
    chain   => 'INPUT',
    action  => 'accept',
    proto   => 'udp',
    iniface => 'docker_gwbridge',
    # statsd
    dport   => [9125],
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
