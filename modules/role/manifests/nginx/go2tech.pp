# Class for go2tech.de nginx configurations
class role::nginx::go2tech {
  file { '/data/shareddata/www/go2tech.de':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/shareddata/www/go2tech.de/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  nginx::resource::server { '_':
    www_root             => '/data/shareddata/www/go2tech.de/public_html',
    ipv6_enable          => true,
    listen_options       => 'default_server',
    index_files          => [ 'missing.php' ],
    add_header           => { 'X-Delivered-By' => $facts['fqdn'] },
    use_default_location => false,
  }

  nginx::resource::location { '_ php':
    server   => '_',
    location => '~ \.php$',
    fastcgi  => '$mediawikibackend',
  }

  nginx::resource::server { 'go2tech.de.80':
    server_name          => [ 'go2tech.de', 'www.go2tech.de' ],
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    add_header           => {
      'X-Delivered-By' => $facts['fqdn'],
    },
    server_cfg_append    => {
      'return' => '301 https://$host$request_uri',
    },
    index_files          => [],
    use_default_location => false,
  }

  nginx::resource::server { 'go2tech.de':
    server_name          => [ 'go2tech.de', 'bits.go2tech.de', '188.68.49.74' ],
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    www_root             => '/data/shareddata/www/go2tech.de/public_html',
    index_files          => [ 'index.php' ],
    listen_port          => 443,
    ssl_port             => 443,
    ssl                  => true,
    ssl_cert             => hiera('nginx::tls::fullchain'),
    ssl_key              => hiera('nginx::tls::privkey'),
    ssl_dhparam          => $sslcert::params::dhparampempath,
    ssl_stapling         => true,
    ssl_stapling_verify  => true,
    http2                => on,
    add_header           => {
      'X-Delivered-By'            => $facts['fqdn'],
      'Strict-Transport-Security' => 'max-age=31536000; preload',
    },
    server_cfg_append    => {
      'error_page 404' => '/404.html',
    },
    use_default_location => false,
  }

  monit::certcheck { 'go2tech.de': }

  nginx::resource::location {
    default:
      server   => 'go2tech.de',
      ssl      => true,
      ssl_only => true,
    ;
    'go2tech.de php':
      location => '~ \.php$',
      fastcgi  => '$mediawikibackend',
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
      proxy                 => 'http://eclair.dwnet:2812',
      proxy_set_header      => [
        'Host $host',
        'X-Forwarded-For $remote_addr',
      ],
      proxy_connect_timeout => '300',
    ;
    'go2tech.de/named/':
      location              => '/named/',
      proxy                 => "http://172.16.0.2:8081/",
      auth_basic            => 'Restricted',
      auth_basic_user_file  => '/data/shareddata/www/go2tech.de/access.htpasswd',
      proxy_set_header      => [
        'Host $host',
        'X-Forwarded-For $remote_addr',
      ],
      proxy_connect_timeout => '300',
      raw_append            => [
        "sub_filter \"/bind9.xsl\" \"/named/bind9.xsl\";",
        "sub_filter \"/xml\" \"/named/xml\";",
        "sub_filter \"href=\\\"/\\\"\" \"href=\\\"/named/\\\"\";",
        "sub_filter_once off;",
        "sub_filter_types \"text/xml\" \"text/xslt+xml\";",
      ],
    ;
  }
}
