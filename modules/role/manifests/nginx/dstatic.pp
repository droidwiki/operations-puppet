# dstatic serves static resources to MediaWiki wikis
class role::nginx::dstatic {
  $add_header = {
    'X-Delivered-By'            => $facts['fqdn'],
    'Strict-Transport-Security' => 'max-age=31536000; includeSubdomains; preload',
  }

  file { '/data/www/dstatic.dev':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/www/dstatic.dev/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }
  $public_html = '/data/www/dstatic/public_html'

  $server_names = [ 'dstatic.dev' ]

  nginx::resource::server { 'dstatic.dev':
    listen_port          => 443,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    ssl                  => true,
    ssl_port             => 443,
    ssl_cert             => '/etc/letsencrypt/live/dstatic.dev/fullchain.pem',
    ssl_key              => '/etc/letsencrypt/live/dstatic.dev/privkey.pem',
    ssl_dhparam          => $sslcert::params::dhparampempath,
    ssl_stapling         => true,
    ssl_stapling_verify  => true,
    http2                => 'on',
    add_header           => $add_header,
    use_default_location => false,
    server_name          => $server_names,
    www_root             => '/data/www/dstatic.dev/public_html/',
    index_files          => [ 'index.php' ],
    server_cfg_append    => {
      'error_page 500 502 503 504' => '/500.html',
      'error_page 403'             => '/403.html',
      'gzip'                       => 'on',
      'gzip_comp_level'            => '2',
      'gzip_http_version'          => '1.0',
      'gzip_proxied'               => 'any',
      'gzip_min_length'            => '1100',
      'gzip_buffers'               => '16 8k',
      # disable gzip for IE < 6 because of known problems
      'gzip_disable'               => '"MSIE [1-6].(?!.*SV1)"',
      'gzip_vary'                  => 'on',
    },
    gzip_types           => 'text/plain text/css application/x-javascript text/xml application/xml application/xml+rss text/javascript',
  }

  nginx::resource::location {
    default:
      server              => 'dstatic.dev',
      location_custom_cfg => {},
      ssl                 => true,
      ssl_only            => true,
    ;
    'dstatic.dev/':
      location  => '/',
    ;
    'dstatic.dev/ @thumb':
      location      => '@thumb',
      rewrite_rules => [
        "^/w/images/thumb/[0-9a-f]/[0-9a-f][0-9a-f]/([^/]+)/([0-9]+)px-.*\$ /w/thumb.php?f=\$1&width=\$2",
        "^/w/images/thumb/archive/[0-9a-f]/[0-9a-f][0-9a-f]/([^/]+)/([0-9]+)px-.*\$ /w/thumb.php?f=\$1&width=\$2&archived=1",
      ],
      fastcgi_param => {
        'SCRIPT_FILENAME' => '$document_root/thumb.php',
      },
      fastcgi       => '$mediawikibackend',
    ;
    'dstatic.dev/wiki/w':
      location      => '~ /(.*)/w/(load|thumb).php',
      rewrite_rules => [
        '^/(.*)/w/(.*).php?(.*)$ /w/$2.php?wiki=$1&$2 last'
      ]
    ;
    'dstatic.dev/w':
      www_root            => '/data/mediawiki/main',
      location            => '/w/',
      location_custom_cfg => {
        '' => 'internal'
      },
      # workaround for missing way for locations in location
      # https://github.com/jfryman/puppet-nginx/issues/692
      raw_prepend         => [
        'location ~ \.php$ {',
        '   if ($request_filename ~ "thumb.php$") {',
        '     add_header Access-Control-Allow-Origin "*";',
        '     add_header Access-Control-Allow-Methods "GET, OPTIONS";',
        '     add_header Access-Control-Allow-Headers "User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range";',
        '     add_header Access-Control-Expose-Headers "Content-Length,Content-Range,X-Cache,X-Varnish,Age,Date";',
        '   }',
        '   fastcgi_param HTTP_ACCEPT_ENCODING "";',
        '   include /etc/nginx/fastcgi_params;',
        '   fastcgi_pass $mediawikibackend;',
        '}',
      ],
    ;
    'dstatic.dev/static':
      location => '/static/',
      www_root => '/data/mediawiki/main/',
  }
}
