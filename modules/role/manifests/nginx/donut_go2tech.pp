# Class for go2tech.de nginx configurations
class role::nginx::donut_go2tech {
  file { '/data/www/donut.go2tech.de':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/www/donut.go2tech.de/donut.go2tech.de.crt':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/role/certificates/donut.go2tech.de.crt',
  }

  file { '/data/www/donut.go2tech.de/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  nginx::resource::vhost { 'donut.go2tech.de.80':
    server_name          => [ 'donut.go2tech.de' ],
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

  nginx::resource::vhost { 'donut.go2tech.de':
    server_name          => [ 'donut.go2tech.de' ],
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    www_root             => '/data/www/donut.go2tech.de/public_html',
    index_files          => [ 'index.php' ],
    listen_port          => 443,
    ssl_port             => 443,
    ssl                  => true,
    ssl_cert             => '/data/www/donut.go2tech.de/donut.go2tech.de.crt',
    ssl_key              => '/data/www/donut.go2tech.de/donut.go2tech.de.key',
    ssl_dhparam          => $sslcert::params::dhparampempath,
    http2                => on,
    add_header           => { 'X-Delivered-By' => $facts['fqdn'] },
    vhost_cfg_append     => {
      'error_page 404' => '/404.html',
    },
    use_default_location => false,
  }

  nginx::resource::location {
    default:
      vhost    => 'donut.go2tech.de',
      ssl      => true,
      ssl_only => true,
    ;
    'donut.go2tech.de php':
      location => '~ \.php$',
      fastcgi  => '127.0.0.1:9000',
    ;
    'donut.go2tech.de/monit':
      location            => '/monit',
      location_custom_cfg => {
        'return' => '301 /monit/',
      },
    ;
    'donut.go2tech.de/monit/':
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