# defines hosts and locations for jenkins.go2tech.de
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
    server_name          => [ 'jenkins.go2tech.de' ],
  }

  nginx::resource::location {
    default:
      vhost => 'jenkins.go2tech.de',
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
}
