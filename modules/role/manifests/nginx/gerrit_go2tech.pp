# defines hosts and locations for gerrit.go2tech.de
# ALWAYS PAIR WITH CERTBOT!
class role::nginx::gerrit_go2tech {
  file { '/data/www/gerrit.go2tech.de':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/www/gerrit.go2tech.de/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  $sslcert = '/etc/letsencrypt/live/blog.go2tech.de-0001/fullchain.pem';
  $sslkey = '/etc/letsencrypt/live/blog.go2tech.de-0001/privkey.pem';

  nginx::resource::vhost { 'gerrit.go2tech.de':
    use_default_location => false,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    server_name          => [ 'gerrit.go2tech.de' ],
    listen_port          => 443,
    ssl_port             => 443,
    ssl                  => true,
    ssl_cert             => $sslcert,
    ssl_key              => $sslkey,
    ssl_dhparam          => $sslcert::params::dhparampempath,
    ssl_stapling         => true,
    ssl_stapling_verify  => true,
    http2                => on,
  }

  monit::certcheck { 'gerrit.go2tech.de': }

  nginx::resource::vhost { 'gerrit.go2tech.de.80':
    server_name          => [ 'gerrit.go2tech.de' ],
    listen_port          => 80,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    ssl                  => false,
    add_header           => {
      'X-Delivered-By' => $facts['fqdn'],
    },
    index_files          => [],
    vhost_cfg_append     => {
      'return' => '301 https://gerrit.go2tech.de$request_uri',
    },
    use_default_location => false,
  }

  nginx::resource::location { 'gerrit.go2tech.de/':
    vhost                 => 'gerrit.go2tech.de',
    ssl                   => true,
    ssl_only              => true,
    location              => '/',
    proxy                 => 'http://127.0.0.1:8081',
    proxy_set_header      => [
      'Host $host',
      'X-Real-IP $remote_addr',
      'X-Forwarded-For $remote_addr',
    ],
    proxy_connect_timeout => '300',
    location_cfg_append   => {
      'port_in_redirect' => 'off',
    },
  }

  nginx::resource::location { 'gerrit.go2tech.de/.well-known':
    vhost    => 'gerrit.go2tech.de',
    ssl      => true,
    ssl_only => true,
    location => '^~ /.well-known/acme-challenge/',
    www_root => '/data/www/gerrit.go2tech.de/public_html/',
  }
}
