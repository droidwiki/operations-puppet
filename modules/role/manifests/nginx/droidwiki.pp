# nginx vhost droidwiki.de
# ALWAYS PAIR WITH CERTBOT!
class role::nginx::droidwiki {
  file { '/data/www/droidwiki.de':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/www/droidwiki.de/droidwiki.de.2017.crt':
    ensure => 'absent',
  }

  file { '/data/www/droidwiki.de/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  $sslcert = hiera('nginx::tls::fullchain');
  $sslkey = hiera('nginx::tls::privkey');

  droidwiki::nginx::mediawiki { 'www.droidwiki.org':
    vhost_url             => 'www.droidwiki.org',
    server_name           => [ 'www.droidwiki.org' ],
    manage_directories    => false,
    html_root             => '/data/mediawiki/mw-config/mw-config/docroot',
    listen_port           => 80,
    ssl                   => false,
    http2                 => 'off',
    manage_http_redirects => false,
  }

  monit::certcheck { 'www.droidwiki.org': }

  $droidwiki_domains = [ '.droid.wiki', '.droidwiki.de', '.droid-wiki.org', '.droidwiki.org' ]

  nginx::resource::server { 'www.droidwiki.org.external':
    listen_port          => 443,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    ssl                  => true,
    ssl_port             => $ssl_port,
    ssl_cert             => $sslcert,
    ssl_key              => $sslkey,
    ssl_dhparam          => $sslcert::params::dhparampempath,
    http2                => 'on',
    ssl_stapling         => true,
    ssl_stapling_verify  => true,
    use_default_location => false,
    server_name          => [ 'www.droidwiki.org' ],
    www_root             => '/data/mediawiki/main',
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

  nginx::resource::location { "www.droidwiki.org.external/":
    location      => '/',
    server        => 'www.droidwiki.org.external',
    ssl           => true,
    ssl_only      => true,
    proxy         => 'http://172.16.0.1:6081',
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
      ssl_dhparam          => $sslcert::params::dhparampempath,
      http2                => on,
      add_header           => {
        'Strict-Transport-Security' => 'max-age=31536000; includeSubdomains; preload',
      },
      server_cfg_append    => {
        'return' => '301 https://www.droidwiki.org$request_uri',
      },
      use_default_location => false,
    ;
    'droidwiki.de':
      server_name      => $droidwiki_domains,
    ;
    'www.droidwiki.de':
      server_name      => [ 'www.droidwiki.de' ],
    ;
    'droidwiki.de.80':
      server_name => $droidwiki_domains,
      listen_port => 80,
      ssl         => false,
      index_files => [],
    ;
  }
}
