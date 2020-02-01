# nginx vhost missionrhode.go2tech.de
class role::nginx::missionrhode_go2tech {
  file { '/data/shareddata/www/missionrhode.go2tech.de':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/shareddata/www/missionrhode.go2tech.de/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  nginx::resource::server { 'missionrhode.go2tech.de':
    listen_port          => 443,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    ssl                  => true,
    ssl_port             => 443,
    ssl_cert             => hiera('nginx::tls::fullchain'),
    ssl_key              => hiera('nginx::tls::privkey'),
    ssl_stapling         => true,
    ssl_stapling_verify  => true,
    ssl_dhparam          => $sslcert::params::dhparampempath,
    http2                => 'on',
    add_header           => {
      'X-Delivered-By'            => $facts['fqdn'],
      'Strict-Transport-Security' => 'max-age=31536000; includeSubdomains; preload',
    },
    server_name          => [ 'missionrhode.go2tech.de' ],
    use_default_location => false,
    www_root             => '/data/shareddata/www/missionrhode.go2tech.de/public_html',
    format_log           => 'buffer=4k',
    index_files          => [ 'index.php' ],
    server_cfg_append    => {
      'gzip'              => 'on',
      'gzip_comp_level'   => '6',
      'gzip_http_version' => '1.0',
      'gzip_proxied'      => 'any',
      'gzip_min_length'   => '1100',
      'gzip_buffers'      => '16 8k',
      # disable gzip for IE < 6 because of known problems
      'gzip_disable'      => '"MSIE [1-6].(?!.*SV1)"',
      'gzip_vary'         => 'on',
    },
    gzip_types           => 'application/xml+rss text/html text/css text/javascript text/xml text/plain text/x-component application/javascript application/x-javascript application/json application/xml application/rss+xml application/atom+xml font/truetype font/opentype application/vnd.ms-fontobject image/svg+xml text/x-js',
  }

  monit::certcheck { 'missionrhode.go2tech.de': }

  nginx::resource::location {
    default:
      server   => 'missionrhode.go2tech.de',
      ssl      => true,
      ssl_only => true,
    ;
    'missionrhode.go2tech.de/':
      location  => '/',
      try_files => [ '$uri', '$uri/', '/index.php?$args' ]
    ;
    'missionrhode.go2tech.de php':
      location  => '~ \.php$',
      try_files => [ '$uri', '$uri/', '=404' ],
      fastcgi   => '$mediawikibackend',
    ;
  }

  # some redirects
  nginx::resource::server {
    default:
      ipv6_enable          => true,
      ipv6_listen_options  => '',
      add_header           => {
        'X-Delivered-By'            => $facts['fqdn'],
      },
      server_cfg_append    => {
        'return' => '301 https://missionrhode.go2tech.de$request_uri',
      },
      use_default_location => false,
      format_log           => 'buffer=4k',
    ;
    'missionrhode.go2tech.de.80':
      server_name => [ 'missionrhode.go2tech.de' ],
      listen_port => 80,
      ssl         => false,
      add_header  => {
        'X-Delivered-By' => $facts['fqdn'],
      },
      index_files => [],
    ;
  }
}
