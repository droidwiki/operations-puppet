# vhosts and locations for www.go2tech.de
class role::nginx::www_go2tech {
  file { '/data/www/www.go2tech.de':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/www/www.go2tech.de/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  nginx::resource::vhost { 'www.go2tech.de':
    listen_port          => 443,
    use_default_location => false,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    server_name          => [ 'www.go2tech.de' ],
    ssl_port             => 443,
    ssl                  => true,
    ssl_cert             => '/data/www/go2tech.de/go2tech.de.crt',
    ssl_key              => '/data/www/go2tech.de/go2tech.de.key',
    ssl_dhparam          => $sslcert::params::dhparampempath,
    ssl_stapling         => true,
    ssl_stapling_verify  => true,
    http2                => on,
    www_root             => '/data/www/www.go2tech.de/public_html/',
    index_files          => [ 'index.html' ],
  }

  nginx::resource::vhost { 'www.go2tech.de.80':
    server_name          => [ 'www.go2tech.de' ],
    listen_port          => 80,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    ssl                  => false,
    add_header           => {
      'X-Delivered-By' => $facts['fqdn'],
    },
    index_files          => [],
    vhost_cfg_append     => {
      'return' => '301 https://www.go2tech.de$request_uri',
    },
    use_default_location => false,
  }

  nginx::resource::location { 'www.go2tech.de/':
    vhost       => 'www.go2tech.de',
    ssl         => true,
    ssl_only    => true,
    location    => '/',
    index_files => [ 'index.html' ],
    www_root    => '/data/www/www.go2tech.de/public_html/',
  }
}
