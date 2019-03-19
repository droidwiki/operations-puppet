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
    listen_port           => 443,
    ssl                   => true,
    ssl_cert              => $sslcert,
    ssl_key               => $sslkey,
    manage_http_redirects => false,
  }

  monit::certcheck { 'www.droidwiki.org': }

  $droidwiki_domains = [ '.droid.wiki', '.droidwiki.de', '.droid-wiki.org', '.droidwiki.org' ]

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
