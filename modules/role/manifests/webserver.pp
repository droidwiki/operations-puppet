# Generic class for a webserver installation
# currently only handles the firewall rules
class role::webserver {
  firewall { '304 accept incoming http traffic':
    proto  => 'tcp',
    dport  => '80',
    action => 'accept',
  }

  firewall { '304 accept incoming http traffic IPv6':
    proto    => 'tcp',
    dport    => '80',
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '305 accept incoming https traffic':
    proto  => 'tcp',
    dport  => '443',
    action => 'accept',
  }

  firewall { '305 accept incoming https traffic IPv6':
    proto    => 'tcp',
    dport    => '443',
    action   => 'accept',
    provider => 'ip6tables',
  }

  class { '::varnish':
    secret      => hiera('varnish::secret'),
    listen      => '0.0.0.0',
    listen_port => 6081,
  }

  ::varnish::vcl { '/etc/varnish/default.vcl':
    content => template('role/varnish/default.vcl.erb'),
  }

  # deploy our own key exchange parameter for every webserver host
  class { 'sslcert::dhparam': }

  # install nginx, but don't configure any hosts
  class { 'nginx':
    manage_repo    => true,
    package_source => 'nginx-mainline',
  }

  monit::service { 'nginx': }
  monit::service { 'varnish': }

  file { '/data/www':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0775',
  }

  file { "${nginx::conf_dir}/conf.d/upstrean-selector.conf":
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/role/upstream-selector.conf',
    notify => Service['nginx']
  }

}
