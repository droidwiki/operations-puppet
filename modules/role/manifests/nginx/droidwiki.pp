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

  droidwiki::nginx::mediawiki { 'www.droidwiki.org':
    vhost_url             => 'www.droidwiki.org',
    server_name           => [ 'www.droidwiki.org' ],
    manage_directories    => false,
    html_root             => '/data/mediawiki/mw-config/mw-config/docroot',
    listen_port           => 443,
    ssl                   => true,
    ssl_cert              => '/etc/letsencrypt/live/droidwiki.de/fullchain.pem',
    ssl_key               => '/etc/letsencrypt/live/droidwiki.de/privkey.pem',
    manage_http_redirects => false,
  }

  # some redirects
  nginx::resource::vhost {
    default:
      listen_port          => 443,
      ipv6_enable          => true,
      ipv6_listen_options  => '',
      ssl_port             => 443,
      ssl                  => true,
      ssl_cert             => '/etc/letsencrypt/live/droidwiki.de/fullchain.pem',
      ssl_key              => '/etc/letsencrypt/live/droidwiki.de/privkey.pem',
      ssl_stapling         => true,
      ssl_stapling_verify  => true,
      ssl_dhparam          => $sslcert::params::dhparampempath,
      http2                => on,
      add_header           => {
        'X-Delivered-By'            => $facts['fqdn'],
        'Strict-Transport-Security' => '"max-age=31536000; includeSubdomains; preload"',
      },
      vhost_cfg_append     => {
        'return' => '301 https://www.droidwiki.org$request_uri',
      },
      use_default_location => false,
    ;
    'droidwiki.de':
      server_name      => [ '.droid.wiki', '.droidwiki.de', '.droidwiki.org' ],
    ;
    'www.droidwiki.de':
      server_name      => [ 'www.droidwiki.de' ],
    ;
    'droidwiki.de.80':
      server_name => [ '.droid.wiki', '.droidwiki.org', '.droidwiki.de' ],
      listen_port => 80,
      ssl         => false,
      add_header  => {
        'X-Delivered-By' => $facts['fqdn'],
      },
      index_files => [],
    ;
  }
}
