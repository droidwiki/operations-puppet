# vhosts and locations for blog.go2tech.de
# ALWAYS PAIR WITH CERTBOT!
class role::nginx::blog_go2tech {
  file { '/data/shareddata/www/blog.go2tech.de':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/shareddata/www/blog.go2tech.de/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  nginx::resource::server { 'blog.go2tech.de':
    listen_port          => 443,
    use_default_location => false,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    server_name          => [ 'blog.go2tech.de' ],
    ssl_port             => 443,
    ssl                  => true,
    ssl_cert             => hiera('nginx::tls::fullchain'),
    ssl_key              => hiera('nginx::tls::privkey'),
    ssl_dhparam          => $sslcert::params::dhparampempath,
    ssl_stapling         => true,
    ssl_stapling_verify  => true,
    http2                => on,
    www_root             => '/data/shareddata/www/blog.go2tech.de/public_html/',
    index_files          => [ 'index.php' ],
  }

  monit::certcheck { 'blog.go2tech.de': }

  nginx::resource::server { 'blog.go2tech.de.80':
    server_name          => [ 'blog.go2tech.de' ],
    listen_port          => 80,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    ssl                  => false,
    add_header           => {
      'X-Delivered-By' => $facts['fqdn'],
    },
    index_files          => [],
    server_cfg_append    => {
      'return' => '301 https://blog.go2tech.de$request_uri',
    },
    use_default_location => false,
  }

  nginx::resource::location { 'blog.go2tech.de/':
    server              => 'blog.go2tech.de',
    ssl                 => true,
    ssl_only            => true,
    location            => '/',
    try_files => [ '$uri', '$uri/', '/index.php?$args' ],
  }

  nginx::resource::location { 'blog.go2tech.de php':
    ssl      => true,
    ssl_only => true,
    server   => 'blog.go2tech.de',
    location => '~ \.php$',
    fastcgi  => 'mediawikibackend',
  }
}
