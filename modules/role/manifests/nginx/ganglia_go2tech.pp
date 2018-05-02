# defines hosts and locations for ganglia.go2tech.de
class role::nginx::ganglia_go2tech {
  file { '/data/www/ganglia.go2tech.de':
    ensure => 'directory',
    force  => true,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/www/ganglia.go2tech.de/public_html':
    ensure => 'directory',
    force  => true,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  nginx::resource::vhost { 'ganglia.go2tech.de':
    ensure               => 'present',
    use_default_location => false,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    server_name          => [ 'ganglia.go2tech.de' ],
    www_root             => '/data/www/ganglia.go2tech.de/public_html',
  }

  nginx::resource::location { 'ganglia.go2tech.de/ .php':
    ensure   => 'present',
    vhost    => 'ganglia.go2tech.de',
    location => '~ \.php',
    fastcgi  => '127.0.0.1:9000',
  }
}
