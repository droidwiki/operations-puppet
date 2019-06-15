# defines hosts and locations for ganglia.go2tech.de
class role::nginx::ganglia_go2tech {
  nginx::resource::server { 'ganglia.go2tech.de':
    ensure               => 'present',
    use_default_location => false,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    server_name          => [ 'ganglia.go2tech.de' ],
    www_root             => '/data/shareddata/www/ganglia.go2tech.de/public_html',
  }

  nginx::resource::location { 'ganglia.go2tech.de/':
    ensure    => 'present',
    server    => 'ganglia.go2tech.de',
    location  => '/',
    try_files => [ '$uri', '$uri/', '/index.php?$args' ],
  }

  nginx::resource::location { 'ganglia.go2tech.de/ .php':
    ensure   => 'present',
    server   => 'ganglia.go2tech.de',
    location => '~ \.php',
    fastcgi  => '172.16.0.2:9000',
  }
}
