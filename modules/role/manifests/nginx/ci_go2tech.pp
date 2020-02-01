# defines hosts and locations for ci.go2tech.de
# ALWAYS PAIR WITH CERTBOT!
class role::nginx::ci_go2tech {
  file { '/data/shareddata/www/ci.go2tech.de':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/shareddata/www/ci.go2tech.de/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  nginx::resource::server { 'ci.go2tech.de':
    use_default_location => false,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    server_name          => [ 'ci.go2tech.de' ],
    listen_port          => 443,
    ssl_port             => 443,
    ssl                  => true,
    ssl_cert             => hiera('nginx::tls::fullchain'),
    ssl_key              => hiera('nginx::tls::privkey'),
    ssl_dhparam          => $sslcert::params::dhparampempath,
    ssl_stapling         => true,
    ssl_stapling_verify  => true,
    http2                => on,
    format_log           => 'combined buffer=4k',
  }

  nginx::resource::server { 'ci.go2tech.de.80':
    server_name          => [ 'ci.go2tech.de' ],
    listen_port          => 80,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    ssl                  => false,
    add_header           => {
      'X-Delivered-By' => $facts['fqdn'],
    },
    index_files          => [],
    use_default_location => false,
    format_log           => 'combined buffer=4k',
  }

  nginx::resource::location { 'ci.go2tech.de/':
    server                => 'ci.go2tech.de',
    ssl                   => true,
    ssl_only              => true,
    location              => '/',
    proxy                 => 'http://172.16.0.2:8080',
    proxy_set_header      => [
      'Host $host',
      'X-Forwarded-For $remote_addr',
    ],
    proxy_connect_timeout => '300',
    location_cfg_append   => {
      'port_in_redirect' => 'off',
    },
  }

  nginx::resource::location { 'ci.go2tech.de/hijack':
    server                => 'ci.go2tech.de',
    ssl                   => true,
    ssl_only              => true,
    location              => '~ /hijack$',
    proxy                 => 'http://172.16.0.2:8080',
    proxy_set_header      => [
      'Host $host',
      'X-Forwarded-For $remote_addr',
      'Upgrade $http_upgrade',
      'Connection "upgrade"',
      'Connection ""',
    ],
    proxy_http_version    => '1.1',
    proxy_buffering       => 'off',
    proxy_redirect        => 'off',
    proxy_connect_timeout => '300',
    location_cfg_append   => {
      'port_in_redirect' => 'off',
    },
  }

  nginx::resource::location { 'ci.go2tech.de.80/':
    server              => 'ci.go2tech.de.80',
    location            => '/',
    location_custom_cfg => {
      'return ' => '301 https://ci.go2tech.de$request_uri',
    },
  }
}
