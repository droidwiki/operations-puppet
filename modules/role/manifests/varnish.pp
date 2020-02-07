# Configures varnish, independant from any forwarding webserver
class role::varnish {
  class { '::varnish':
    secret      => hiera('varnish::secret'),
    listen      => '0.0.0.0',
    listen_port => 6081,
  }
 
  ::varnish::vcl { '/etc/varnish/default.vcl':
    content => template('role/varnish/default.vcl.erb'),
  }

  monit::service { 'varnish': }
}
