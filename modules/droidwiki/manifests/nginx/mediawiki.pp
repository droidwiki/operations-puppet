# template for nginx conifguration for a standard
# mediawiki host.
define droidwiki::nginx::mediawiki (
  $vhost_url          = undef,
  $manage_directories = true,
  $server_name        = undef,
  $html_root          = undef,
  $mediawiki_wwwroot  = '/data/mediawiki/main',
) {
  validate_string($vhost_url)
  validate_bool($manage_directories)
  if ( $manage_directories ) {
    file { "/data/www/${vhost_url}":
      ensure => 'directory',
      owner  => 'www-data',
      group  => 'www-data',
      mode   => '0755',
    }

    $public_html = "/data/www/${vhost_url}/public_html"
    file { "/data/www/${vhost_url}/public_html":
      ensure => 'directory',
      owner  => 'www-data',
      group  => 'www-data',
      mode   => '0755',
    }
  } else {
      $public_html = $html_root
  }

  if ( $server_name != undef ) {
    validate_array($server_name)
    $server_names = $server_name
  } else {
    $server_names = [ $vhost_url ]
  }

  nginx::resource::vhost { $vhost_url:
    ssl                  => false,
    add_header           => {
      'X-Delivered-By' => $facts['fqdn'],
    },
    use_default_location => false,
    server_name          => $server_names,
    www_root             => $mediawiki_wwwroot,
    index_files          => [ 'index.php' ],
    vhost_cfg_append     => {
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
      vhost               => $vhost_url,
      location_custom_cfg => {},
    ;
    "${vhost_url}/500.html":
      location => '= /500.html',
      www_root => $public_html,
    ;
    "${vhost_url}/403.html":
      location => '= /403.html',
      www_root => $public_html,
    ;
    "${vhost_url}/":
      location  => '/',
      # FIXME: https://github.com/jfryman/puppet-nginx/issues/470
      location_custom_cfg => {
        'try_files' => '$uri /w/index.php',
      }
    ;
    "${vhost_url}/w/":
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
    "${vhost_url}/w/images":
      location    => '/w/images',
      # workaround for missing way for locations in location
      # https://github.com/jfryman/puppet-nginx/issues/692
      raw_prepend => [
        'location ~ ^/w/images/thumb/(archive/)?[0-9a-f]/[0-9a-f][0-9a-f]/([^/]+)/([0-9]+)px-.*$ {',
        '   try_files $uri $uri/ @thumb;',
        '}',
      ],
    ;
    "${vhost_url}/w/images/deleted":
      location      => '/w/images/deleted',
      location_deny => [ 'all' ],
    ;
    "${vhost_url}/w/cache":
      location      => '/w/cache',
      location_deny => [ 'all' ],
    ;
    "${vhost_url}/w/languages":
      location      => '/w/languages',
      location_deny => [ 'all' ],
    ;
    "${vhost_url}/w/maintenance":
      location      => '/w/maintenance',
      location_deny => [ 'all' ],
    ;
    "${vhost_url}/w/serialized":
      location      => '/w/serialized',
      location_deny => [ 'all' ],
    ;
    "${vhost_url}/ .svn .git":
      location      => '~ /.(svn|git)(/|$)',
      location_deny => [ 'all' ],
    ;
    "${vhost_url}/ .ht":
      location      => '~ /.ht',
      location_deny => [ 'all' ],
    ;
    "${vhost_url}/wiki":
      location      => '/wiki',
      fastcgi_param => {
        'SCRIPT_FILENAME' => '$document_root/index.php',
      },
      fastcgi       => '127.0.0.1:9000',
    ;
    "${vhost_url}/ @thumb":
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
  }
}
