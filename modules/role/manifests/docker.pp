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

  firewall { '900 accept outgoing requests to DOCKER':
    chain   => 'OUTPUT',
    proto   => 'all',
    jump    => 'DOCKER',
    require => Class['docker'],
  }

  firewall { '901 accept incoming docker gateway requests':
    chain   => 'INPUT',
    action  => 'accept',
    proto   => 'tcp',
    iniface => 'docker_gwbridge',
    # varnishd, php-fpm, monit, concourse
    dport   => [6081, 9000, 2812, 8081],
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
