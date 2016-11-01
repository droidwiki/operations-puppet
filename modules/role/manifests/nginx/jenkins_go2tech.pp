# defines hosts and locations for jenkins.go2tech.de
# ALWAYS PAIR WITH CERTBOT!
class role::nginx::jenkins_go2tech {
  file { '/data/www/jenkins.go2tech.de':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/www/jenkins.go2tech.de/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  nginx::resource::vhost { 'jenkins.go2tech.de':
    use_default_location => false,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    server_name          => [ 'jenkins.go2tech.de' ],
    listen_port          => 443,
    ssl_port             => 443,
    ssl                  => true,
    ssl_cert             => '/etc/letsencrypt/live/blog.go2tech.de/fullchain.pem',
    ssl_key              => '/etc/letsencrypt/live/blog.go2tech.de/privkey.pem',
    ssl_dhparam          => $sslcert::params::dhparampempath,
    ssl_stapling         => true,
    ssl_stapling_verify  => true,
    http2                => on,
  }

  nginx::resource::vhost { 'jenkins.go2tech.de.80':
    server_name          => [ 'jenkins.go2tech.de' ],
    listen_port          => 80,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    ssl                  => false,
    add_header           => {
      'X-Delivered-By' => $facts['fqdn'],
    },
    index_files          => [],
    vhost_cfg_append     => {
      'return' => '301 https://jenkins.go2tech.de$request_uri',
    },
    use_default_location => false,
  }

  nginx::resource::location {
    default:
      vhost    => 'jenkins.go2tech.de',
      ssl      => true,
      ssl_only => true,
    ;
    'jenkins.go2tech.de/':
      location              => '/',
      proxy                 => 'http://127.0.0.1:8080',
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
    'jenkins.go2tech.de/zull':
      location    => '/zuul/',
      www_root    => '/data/www/jenkins.go2tech.de/public_html/',
      index_files => [ 'index.html' ],
    ;
    'jenkins.go2tech.de/zuul/status.json':
      location => '/zuul/status.json',
      proxy    => 'http://127.0.0.1:8001/status.json',
    ;
  }

  nginx::resource::location { 'jenkins.go2tech.de/.well-known':
    vhost    => 'jenkins.go2tech.de.80',
    location => '^~ /.well-known/acme-challenge/',
    www_root => '/data/www/jenkins.go2tech.de/public_html/',
  }
}
