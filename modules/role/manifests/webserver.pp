# Generic class for a webserver installation
# currently only handles the firewall rules
class role::webserver {
  firewall { '304 accept incoming http traffic':
    proto  => 'tcp',
    dport  => '80',
    action => 'accept',
  }

  firewall { '305 accept incoming https traffic':
    proto  => 'tcp',
    dport  => '443',
    action => 'accept',
  }

  # deploy our own key exchange parameter for every webserver host
  class { 'sslcert::dhparam': }

  # install nginx, but don't configure any hosts
  class { 'nginx':
    manage_repo    => true,
    package_source => 'nginx-mainline',
  }

  monit::service { 'nginx': }

  file { '/data/www':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0775',
  }
}
