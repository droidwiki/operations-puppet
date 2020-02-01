# nginx vhost droidwiki.de
# ALWAYS PAIR WITH CERTBOT!
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

  $sslcert = hiera('nginx::tls::fullchain');
  $sslkey = hiera('nginx::tls::privkey');

  ['en.droidwiki.org', 'data.droidwiki.org'].each |Integer $index, String $domain| {
    droidwiki::nginx::mediawiki { $domain:
      vhost_url             => $domain,
      server_name           => [ $domain ],
      manage_directories    => false,
      html_root             => '/data/mediawiki/mw-config/mw-config/docroot',
      ssl                   => false,
      http2                 => 'off',
      manage_http_redirects => false,
    }
  }

  droidwiki::nginx::mediawiki { 'www.droidwiki.org':
    vhost_url             => 'www.droidwiki.org',
    server_name           => [ 'www.droidwiki.org', 'droidwiki.org' ],
    manage_directories    => false,
    html_root             => '/data/mediawiki/mw-config/mw-config/docroot',
    ssl                   => false,
    http2                 => 'off',
    manage_http_redirects => false,
  }

  monit::certcheck { 'www.droidwiki.org': }

  nginx::resource::server { 'droidwiki.org.external':
    listen_port          => 443,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    ssl                  => true,
    ssl_port             => 443,
    ssl_cert             => $sslcert,
    ssl_key              => $sslkey,
    ssl_dhparam          => $sslcert::params::dhparampempath,
    http2                => 'on',
    ssl_stapling         => true,
    ssl_stapling_verify  => true,
    use_default_location => false,
    server_name          => [ '.droidwiki.org' ],
    www_root             => '/data/mediawiki/main',
    format_log           => 'buffer=4k',
    index_files          => [ 'index.php' ],
    server_cfg_append    => {
      'error_page 500 502 503 504' => '/500.html',
      'error_page 403'             => '/403.html',
      'gzip'                       => 'on',
      'gzip_comp_level'            => '6',
      'gzip_http_version'          => '1.0',
      'gzip_proxied'               => 'any',
      'gzip_min_length'            => '1100',
      'gzip_buffers'               => '16 8k',
      # disable gzip for IE < 6 because of known problems
      'gzip_disable'               => '"MSIE [1-6].(?!.*SV1)"',
      'gzip_vary'                  => 'on',
    },
    gzip_types           => 'application/xml+rss text/html text/css text/javascript text/xml text/plain text/x-component application/javascript application/x-javascript application/json application/xml application/rss+xml application/atom+xml font/truetype font/opentype application/vnd.ms-fontobject image/svg+xml text/x-js',
  }

  nginx::resource::location { 'droidwiki.org.external/':
    location         => '/',
    server           => 'droidwiki.org.external',
    ssl              => true,
    ssl_only         => true,
    proxy            => 'http://172.16.0.1:6081',
    proxy_set_header => [
      'Host $host',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'X-Forwarded-Proto https',
      'Proxy ""',
    ]
  }

  # some redirects
  nginx::resource::server {
    default:
      listen_port          => 443,
      ipv6_enable          => true,
      ipv6_listen_options  => '',
      ssl_port             => 443,
      ssl                  => true,
      ssl_cert             => $sslcert,
      ssl_key              => $sslkey,
      ssl_stapling         => true,
      ssl_stapling_verify  => true,
      format_log           => 'buffer=4k',
      ssl_dhparam          => $sslcert::params::dhparampempath,
      http2                => on,
      add_header           => {
        'Strict-Transport-Security' => 'max-age=31536000; includeSubdomains; preload',
      },
      use_default_location => false,
    ;
    'droidwiki.domains':
      server_name       => [ '.droid.wiki', '.droid-wiki.org' ],
      server_cfg_append => {
        'return' => '301 https://www.droidwiki.org$request_uri',
      },
    ;
    'droidwiki.http-redirect':
      server_name       => [ '.droid.wiki', '.droid-wiki.org', '.droidwiki.org' ],
      listen_port       => 80,
      ssl               => false,
      index_files       => [],
      server_cfg_append => {
        'return' => '301 https://$host$request_uri',
      },
    ;
  }
}
