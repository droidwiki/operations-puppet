# defines hosts and locations for gerrit.go2tech.de
class role::nginx::gerrit_go2tech {
  nginx::resource::vhost { 'gerrit.go2tech.de':
    use_default_location => false,
    server_name          => [ 'gerrit.go2tech.de' ],
  }

  nginx::resource::location { 'gerrit.go2tech.de/':
    vhost                 => 'gerrit.go2tech.de',
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
}
