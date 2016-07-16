# nginx vhost droidwiki.de
class role::nginx::droidwiki {
  file { '/data/www/droidwiki.de':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/www/droidwiki.de/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  nginx::resource::vhost {
    default:
      listen_port          => 443,
      ssl_port             => 443,
      ssl                  => true,
      ssl_cert             => '/data/www/droidwiki.de/droidwiki.de.2017.crt',
      ssl_key              => '/data/www/droidwiki.de/droidwiki.de.decrypted.key',
      ssl_dhparam          => $sslcert::params::dhparampempath,
      http2                => on,
      add_header           => {
        'X-Delivered-By'            => $facts['fqdn'],
        'Strict-Transport-Security' => '"max-age=31536000; includeSubdomains; preload"',
      },
      use_default_location => false,
    ;
    'www.droidwiki.de':
      server_name          => [ 'www.droidwiki.de' ],
      www_root             => '/data/mediawiki/main',
      index_files          => [ 'index.php' ],
      vhost_cfg_append     => {
        'error_page 403'    => '/403.html',
        'error_page 502'    => '/502.html',
        'gzip'              => 'on',
        'gzip_comp_level'   => '2',
        'gzip_http_version' => '1.0',
        'gzip_proxied'      => 'any',
        'gzip_min_length'   => '1100',
        'gzip_buffers'      => '16 8k',
        # disable gzip for IE < 6 because of known problems
        'gzip_disable'      => '"MSIE [1-6].(?!.*SV1)"',
        'gzip_vary'         => 'on',
      },
      client_max_body_size => '9991145',
      client_body_timeout  => '60',
      gzip_types           => 'text/plain text/css application/x-javascript text/xml application/xml application/xml+rss text/javascript',
    ;
    'droidwiki.de':
      server_name      => [ '.droid.wiki', '.droidwiki.de' ],
      vhost_cfg_append => {
        'return' => '301 https://www.droidwiki.de$request_uri',
      },
    ;
    'droidwiki.de.80':
      server_name      => [ '.droid.wiki', '.droidwiki.de' ],
      listen_port      => 80,
      ssl              => false,
      add_header       => {
        'X-Delivered-By'            => $facts['fqdn'],
      },
      vhost_cfg_append => {
        'return' => '301 https://www.droidwiki.de$request_uri',
      },
      index_files      => [],
    ;
  }

  nginx::resource::location {
    default:
      vhost               => 'www.droidwiki.de',
      ssl                 => true,
      ssl_only            => true,
      location_custom_cfg => {},
    ;
    'droidwiki.de/':
      location            => '/',
      # FIXME: https://github.com/jfryman/puppet-nginx/issues/470
      location_custom_cfg => {
        'try_files' => '$uri $uri/ @rewrite',
      }
    ;
    'droidwiki.de @rewrite':
      location            => '@rewrite',
      location_custom_cfg => {
        'rewrite' => '^/(.*)$ /index.php?title=$1&$args',
      }
    ;
    'droidwiki.de .php':
      location      => '~ \.php$',
      try_files     => [ '$uri', '$uri/', '@rewrite' ],
      raw_prepend   => [
        'set $hhvmServer 127.0.0.1:9000;',
        'if ($http_x_droidwiki_debug) {',
        '   set $hhvmServer 188.68.49.74:9000;',
        '   add_header X-Delivered-By eclair.dwnet;',
        '}',
        'if ($http_x_droidwiki_debug = "") {',
        "   add_header X-Delivered-By ${facts['fqdn']};",
        '}',
      ],
      fastcgi       => '$hhvmServer',
      fastcgi_param => {
        'HTTP_ACCEPT_ENCODING' => '""',
      }
    ;
    'droidiwki.de/maintenance':
      location            => '/maintenance',
      location_custom_cfg => {
        'return' => '403',
      },
    ;
    'droidwiki.de images':
      location            => '~* \.(js|css|png|jpg|jpeg|gif|ico)$',
      location_custom_cfg => {
        'try_files'     => '$uri $uri/ /index.php',
        'expires'       => 'max',
        'log_not_found' => 'off',
      },
    ;
    'droidwiki.de .gif':
      location            => '= /_.gif',
      location_custom_cfg => {
        'expires' => 'max',
        ''        => 'empty_gif',
      },
    ;
    'droidwiki.de/cache':
      location            => '^~ /cache/',
      location_custom_cfg => {
        'deny' => 'all',
      },
    ;
    'droidwiki.de error pages':
      location            => '~ ^/(403|502).html',
      www_root            => '/data/mediawiki/mw-config/mw-config/docroot',
      internal            => true,
      location_cfg_append => {
        'allow' => 'all',
      },
    ;
  }
}
