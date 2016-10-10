# Generic class for a webserver installation
# currently only handles the firewall rules
class role::webserver {
  firewall { '300 accept incoming http traffic':
    proto  => 'tcp',
    dport  => '80',
    action => 'accept',
  }

  firewall { '301 accept outgoing http traffic':
    proto  => 'tcp',
    dport  => '80',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '302 accept outgoing http traffic':
    proto  => 'tcp',
    sport  => '80',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '303 accept incoming https traffic':
    proto  => 'tcp',
    dport  => '443',
    action => 'accept',
  }

  firewall { '304 accept outgoing https traffic':
    proto  => 'tcp',
    dport  => '443',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '305 accept outgoing https traffic':
    proto  => 'tcp',
    sport  => '443',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  # deploy our own key exchange parameter for every webserver host
  class { 'sslcert::dhparam': }

  # install nginx, but don't configure any hosts
  class { 'nginx':
    manage_repo    => true,
    package_source => 'nginx-mainline',
    package_ensure => 'latest',
  }

  class { 'hhvm': }

  monit::service { 'nginx': }
  monit::service { 'hhvm': }

  file { '/data/www':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0775',
  }
}
