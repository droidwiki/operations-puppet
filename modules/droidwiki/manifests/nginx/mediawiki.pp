# template for nginx conifguration for a standard
# mediawiki host.
define droidwiki::nginx::mediawiki (
  $vhost_url             = undef,
  $manage_directories    = true,
  $server_name           = undef,
  $html_root             = undef,
  $listen_port           = 80,
  $ssl                   = false,
  $ssl_port              = 443,
  $ssl_cert              = undef,
  $ssl_key               = undef,
  $http2                 = 'on',
  $ipv6_enable           = true,
  $manage_http_redirects = true,
  $mediawiki_wwwroot     = '/data/mediawiki/main',
  $mediawiki_scriptpath  = 'w/',
  $mediawiki_articlepath = 'wiki/',
) {
  validate_string($vhost_url)
  validate_string($mediawiki_wwwroot)
  validate_string($mediawiki_scriptpath)
  validate_string($mediawiki_articlepath)
  validate_bool($manage_directories)
  validate_bool($ssl)
  validate_bool($ipv6_enable)

  # ssl config is slightly different
  if ( $ssl ) {
    validate_string($ssl_cert)
    validate_string($ssl_key)
    validate_string($http2)
    # FIXME: make HSTS configurable, currently any https mediawiki host uses HSTS
    $add_header = {
      'X-Delivered-By'            => $facts['fqdn'],
      'X-Upstream'                => '$upstream_addr',
      'Strict-Transport-Security' => 'max-age=31536000; includeSubdomains; preload',
    }
  } else {
    $add_header = {
      'X-Delivered-By' => $facts['fqdn'],
      'X-Upstream'     => '$upstream_addr',
    }
  }

  if ( $manage_directories ) {
    file { "/data/www/${vhost_url}":
      ensure => 'directory',
      owner  => 'www-data',
      group  => 'www-data',
      mode   => '0755',
    }

    file { "/data/www/${vhost_url}/public_html":
      ensure => 'directory',
      owner  => 'www-data',
      group  => 'www-data',
      mode   => '0755',
    }
    $public_html = "/data/www/${vhost_url}/public_html"
  } else {
    $public_html = $html_root
  }

  if ( $server_name != undef ) {
    validate_array($server_name)
    $server_names = $server_name
  } else {
    $server_names = [ $vhost_url ]
  }

  nginx::resource::server { $vhost_url:
    listen_port          => $listen_port,
    ipv6_enable          => $ipv6_enable,
    ipv6_listen_options  => '',
    ssl                  => $ssl,
    ssl_port             => $ssl_port,
    ssl_cert             => $ssl_cert,
    ssl_key              => $ssl_key,
    ssl_dhparam          => $sslcert::params::dhparampempath,
    ssl_stapling         => true,
    ssl_stapling_verify  => true,
    http2                => $http2,
    add_header           => $add_header,
    use_default_location => false,
    server_name          => $server_names,
    www_root             => $mediawiki_wwwroot,
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

  if ( $ssl and $manage_http_redirects ) {
    nginx::resource::server { "${vhost_url}.80":
      server_name          => $server_names,
      ipv6_enable          => $ipv6_enable,
      ipv6_listen_options  => '',
      listen_port          => 80,
      ssl                  => false,
      server_cfg_append    => {
        'return' => "301 https://${vhost_url}\$request_uri",
      },
      index_files          => [],
      use_default_location => false,
    }
  }

  nginx::resource::location {
    default:
      server              => $vhost_url,
      location_custom_cfg => {},
      ssl                 => $ssl,
      ssl_only            => $ssl,
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
      try_files => [ '$uri', '@rewrite' ]
    ;
    "${vhost_url} @rewrite":
      location            => '@rewrite',
      location_custom_cfg => {
        'rewrite' => "^/(.*)\$ /${mediawiki_scriptpath}index.php?title=\$1&\$args",
      }
    ;
    "${vhost_url}/${mediawiki_scriptpath}images":
      location    => "~ ^/(${mediawiki_scriptpath})?images/*",
      # workaround for missing way for locations in location
      # https://github.com/jfryman/puppet-nginx/issues/692
      raw_prepend => [
        "location ~ ^/${mediawiki_scriptpath}images/thumb/(archive/)?[0-9a-f]/[0-9a-f][0-9a-f]/([^/]+)/([0-9]+)px-.*\$ {",
        '   try_files $uri $uri/ @thumb;',
        '}',
        'add_header Access-Control-Allow-Origin *;',
      ],
    ;
    "${vhost_url}/${mediawiki_scriptpath}images/deleted":
      location  => "^~ /${mediawiki_scriptpath}images/deleted",
      try_files => [ 'fail', '@rewrite' ],
    ;
    "${vhost_url}/${mediawiki_scriptpath}cache":
      location  => "^~ /${mediawiki_scriptpath}cache",
      try_files => [ 'fail', '@rewrite' ],
    ;
    "${vhost_url}/${mediawiki_scriptpath}languages":
      location  => "^~ /${mediawiki_scriptpath}languages",
      try_files => [ 'fail', '@rewrite' ],
    ;
    "${vhost_url}/${mediawiki_scriptpath}maintenance":
      location  => "^~ /${mediawiki_scriptpath}maintenance/",
      try_files => [ 'fail', '@rewrite' ],
    ;
    "${vhost_url}/${mediawiki_scriptpath}serialized":
      location  => "^~ /${mediawiki_scriptpath}serialized",
      try_files => [ 'fail', '@rewrite' ],
    ;
    "${vhost_url}/ .svn .git":
      location  => '~ /.(svn|git)(/|$)',
      try_files => [ 'fail', '@rewrite' ],
    ;
    "${vhost_url}/ .ht":
      location      => '~ /.ht',
      location_deny => [ 'all' ],
    ;
    "${vhost_url}/ @thumb":
      location      => '@thumb',
      rewrite_rules => [
        "^/${mediawiki_scriptpath}images/thumb/[0-9a-f]/[0-9a-f][0-9a-f]/([^/]+)/([0-9]+)px-.*\$ /${mediawiki_scriptpath}thumb.php?f=\$1&width=\$2",
        "^/${mediawiki_scriptpath}images/thumb/archive/[0-9a-f]/[0-9a-f][0-9a-f]/([^/]+)/([0-9]+)px-.*\$ /${mediawiki_scriptpath}thumb.php?f=\$1&width=\$2&archived=1",
      ],
      fastcgi_param => {
        'SCRIPT_FILENAME' => '$document_root/thumb.php',
      },
      fastcgi       => 'mediawikibackend',
    ;
    "${vhost_url}/api":
      location              => '/api',
      rewrite_rules         => [
        '^  $request_uri',
        '^/api(/.*)  $1  break',
      ],
      proxy                 => "http://127.0.0.1:7231/${vhost_url}\$uri",
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
  }

  # without a different script and article path, the / location already exists. Duplicate locations
  # aren't allowed, which is why the both locations are in an if clause.
  if ( $mediawiki_scriptpath != $mediawiki_articlepath ) {
    nginx::resource::location { "${vhost_url}/${mediawiki_articlepath}":
      server        => $vhost_url,
      ssl           => $ssl,
      ssl_only      => $ssl,
      location      => "/${mediawiki_articlepath}",
      fastcgi_param => {
        'SCRIPT_FILENAME' => '$document_root/index.php',
      },
      fastcgi       => 'mediawikibackend',
    }

    nginx::resource::location { "${vhost_url}/${mediawiki_scriptpath}":
      server              => $vhost_url,
      location            => "/${mediawiki_scriptpath}",
      location_custom_cfg => {},
      ssl                 => $ssl,
      ssl_only            => $ssl,
      # workaround for missing way for locations in location
      # https://github.com/jfryman/puppet-nginx/issues/692
      raw_prepend         => [
        'location ~ \.php$ {',
        '   try_files $uri $uri/ =404;',
        '   fastcgi_param HTTP_ACCEPT_ENCODING "";',
        '   include /etc/nginx/fastcgi_params;',
        '   fastcgi_pass mediawikibackend;',
        '}',
      ],
    }
  } else {
    # otherwise, the .php handler is added to the top level location
    nginx::resource::location { "${vhost_url}/ .php":
      location      => '~ \.php$',
      server        => $vhost_url,
      ssl           => $ssl,
      ssl_only      => $ssl,
      try_files     => [ '$uri', '$uri/', '@rewrite' ],
      fastcgi       => 'mediawikibackend',
      fastcgi_param => {
        'HTTP_ACCEPT_ENCODING' => '""',
      }
    }

    nginx::resource::location { "${vhost_url}/w/":
      location            => '^~ /w/',
      server              => $vhost_url,
      ssl                 => $ssl,
      ssl_only            => $ssl,
      # FIXME: https://github.com/jfryman/puppet-nginx/issues/470
      location_custom_cfg => {
        'try_files' => 'fail @rewrite',
      },
      try_files           => [ 'fail', '@rewrite' ],
    }
  }
}
