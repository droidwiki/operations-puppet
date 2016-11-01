# Class for go2tech.de nginx configurations
class role::nginx::go2tech {
  file { '/data/www/go2tech.de':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/www/go2tech.de/go2tech.de.crt':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/role/certificates/go2tech.de.crt',
  }

  file { '/data/www/go2tech.de/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  nginx::resource::vhost { '_':
    www_root             => '/data/www/go2tech.de/public_html',
    ipv6_enable          => true,
    listen_options       => 'default_server',
    index_files          => [ 'missing.php' ],
    add_header           => { 'X-Delivered-By' => $facts['fqdn'] },
    use_default_location => false,
  }

  nginx::resource::location { '_ php':
    vhost    => '_',
    location => '~ \.php$',
    fastcgi  => '127.0.0.1:9000',
  }

  nginx::resource::vhost { 'go2tech.de.80':
    server_name          => [ 'go2tech.de', 'www.go2tech.de' ],
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    add_header           => {
      'X-Delivered-By' => $facts['fqdn'],
    },
    vhost_cfg_append     => {
      'return' => '301 https://$host$request_uri',
    },
    index_files          => [],
    use_default_location => false,
  }

  nginx::resource::vhost { 'go2tech.de':
    server_name          => [ 'go2tech.de', 'bits.go2tech.de', '188.68.49.74' ],
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    www_root             => '/data/www/go2tech.de/public_html',
    index_files          => [ 'index.php' ],
    listen_port          => 443,
    ssl_port             => 443,
    ssl                  => true,
    ssl_cert             => '/data/www/go2tech.de/go2tech.de.crt',
    ssl_key              => '/data/www/go2tech.de/go2tech.de.key',
    ssl_dhparam          => $sslcert::params::dhparampempath,
    ssl_stapling         => true,
    ssl_stapling_verify  => true,
    http2                => on,
    add_header           => {
      'X-Delivered-By'            => $facts['fqdn'],
      'Strict-Transport-Security' => '"max-age=31536000; preload"',
    },
    vhost_cfg_append     => {
      'error_page 404' => '/404.html',
    },
    use_default_location => false,
  }

  nginx::resource::location {
    default:
      vhost    => 'go2tech.de',
      ssl      => true,
      ssl_only => true,
    ;
    'go2tech.de php':
      location => '~ \.php$',
      fastcgi  => '127.0.0.1:9000',
    ;
    'go2tech.de/webssh':
      location              => '/webssh',
      proxy                 => 'https://127.0.0.1:4200/',
      proxy_set_header      => [
        'Host $host',
        'X-Real-IP $remote_addr',
        'X-Forwarded-For $remote_addr',
      ],
      proxy_connect_timeout => '300',
      location_cfg_append   => {
        'port_in_redirect' => 'off',
      },
    ;
    'go2tech.de/monit':
      location            => '/monit',
      location_custom_cfg => {
        'return' => '301 /monit/',
      },
    ;
    'go2tech.de/monit/':
      location              => '/monit/',
      rewrite_rules         => [
        '^/monit/(.*) /$1 break',
      ],
      proxy                 => 'http://127.0.0.1:2812',
      proxy_set_header      => [
        'Host $host',
        'X-Real-IP $remote_addr',
        'X-Forwarded-For $remote_addr',
      ],
      proxy_connect_timeout => '300',
    ;
  }
}
