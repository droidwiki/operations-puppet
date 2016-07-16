# vhosts and locations for grafana.go2tech.de
class role::nginx::grafana_go2tech {
  nginx::resource::vhost { 'grafana.go2tech.de':
    use_default_location => false,
    server_name          => [ 'grafana.go2tech.de' ],
  }

  nginx::resource::location { 'grafana.go2tech.de/':
    vhost               => 'grafana.go2tech.de',
    location            => '/',
    proxy               => 'http://localhost:3000',
  }
}
