# data.droidwiki.de class
class role::nginx::data_droidwiki {
  nginx::resource::vhost {
    default:
      add_header           => {
        'X-Delivered-By'            => $facts['fqdn'],
      },
      use_default_location => false,
    ;
    'data.droidwiki.de':
      server_name          => [ 'data.droidwiki.de' ],
      www_root             => '/data/mediawiki/main',
      index_files          => [ 'index.php' ],
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
    'data.droidwiki.de.80':
      server_name      => [ 'data.droidwiki.de' ],
      listen_port      => 80,
      ssl              => false,
      add_header       => {
        'X-Delivered-By' => $facts['fqdn'],
      },
      vhost_cfg_append => {
        'return' => '301 https://data.droidwiki.de$request_uri',
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
    'data.droidwiki.de/':
      vhost               => 'data.droidiwki.de',
      location            => '/',
      # FIXME: https://github.com/jfryman/puppet-nginx/issues/470
      location_custom_cfg => {
        'try_files' => '$uri /w/index.php',
      }
    ;
    'data.droidwiki.de/ w':
      vhost       => 'data.droidiwki.de',
      location    => '/w/',
      # workaround for missing way for locations in location
      # https://github.com/jfryman/puppet-nginx/issues/692
      raw_prepend => [
        'location ~ \.php$ {',
        '   try_files $uri $uri/ =404;',
        '   fastcgi_param HTTP_ACCEPT_ENCODING "";',
        '   include /etc/nginx/fastcgi_params;',
        '   fastcgi_pass 127.0.0.1:9000;',
        '}',
      ],
    ;
    'data.droidwiki.de/w/images':
      vhost       => 'data.droidiwki.de',
      location    => '/w/images',
      # workaround for missing way for locations in location
      # https://github.com/jfryman/puppet-nginx/issues/692
      raw_prepend => [
        'location ~ ^/w/images/thumb/(archive/)?[0-9a-f]/[0-9a-f][0-9a-f]/([^/]+)/([0-9]+)px-.*$ {',
        '   try_files $uri $uri/ @thumb;',
        '}',
      ],
    ;
    'data.droidwiki.de/w/images/deleted':
      vhost         => 'data.droidiwki.de',
      location      => '/w/images/deleted',
      location_deny => [ 'all' ],
    ;
    'data.droidwiki.de/w/cache':
      vhost         => 'data.droidiwki.de',
      location      => '/w/cache',
      location_deny => [ 'all' ],
    ;
    'data.droidwiki.de/w/languages':
      vhost         => 'data.droidiwki.de',
      location      => '/w/languages',
      location_deny => [ 'all' ],
    ;
    'data.droidwiki.de/w/maintenance':
      vhost         => 'data.droidiwki.de',
      location      => '/w/maintenance',
      location_deny => [ 'all' ],
    ;
    'data.droidwiki.de/w/serialized':
      vhost         => 'data.droidiwki.de',
      location      => '/w/serialized',
      location_deny => [ 'all' ],
    ;
    'data.droidwiki.de/ .svn .git':
      vhost         => 'data.droidiwki.de',
      location      => '~ /.(svn|git)(/|$)',
      location_deny => [ 'all' ],
    ;
    'data.droidwiki.de/ .ht':
      vhost         => 'data.droidiwki.de',
      location      => '~ /.ht',
      location_deny => [ 'all' ],
    ;
    'data.droidwiki.de/wiki':
      vhost         => 'data.droidiwki.de',
      location      => '/wiki',
      fastcgi_param => {
        'SCRIPT_FILENAME' => '$document_root/index.php',
      },
      fastcgi       => '127.0.0.1:9000',
    ;
    'data.droidwiki.de/ @thumb':
      vhost         => 'data.droidiwki.de',
      location      => '@thumb',
      rewrite_rules => [
        '^/w/images/thumb/[0-9a-f]/[0-9a-f][0-9a-f]/([^/]+)/([0-9]+)px-.*$ /w/thumb.php?f=$1&width=$2',
        '^/w/images/thumb/archive/[0-9a-f]/[0-9a-f][0-9a-f]/([^/]+)/([0-9]+)px-.*$ /w/thumb.php?f=$1&width=$2&archived=1',
      ],
      fastcgi_param => {
        'SCRIPT_FILENAME' => '$document_root/thumb.php',
      },
      fastcgi       => '127.0.0.1:9000',
    ;
    'data.droidwiki.de error pages':
      vhost               => 'data.droidiwki.de',
      location            => '~ ^/(403|502).html',
      www_root            => '/data/mediawiki/mw-config/mw-config/docroot',
      internal            => true,
      location_cfg_append => {
        'allow' => 'all',
      },
    ;
  }
}
