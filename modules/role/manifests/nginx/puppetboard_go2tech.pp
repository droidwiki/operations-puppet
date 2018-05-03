# defines hosts and locations for puppetboard.go2tech.de
class role::nginx::puppetboard_go2tech {
  file { '/data/www/puppetboard.go2tech.de':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/www/puppetboard.go2tech.de/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  nginx::resource::vhost { 'puppetboard.go2tech.de':
    use_default_location => false,
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    server_name          => [ 'puppetboard.go2tech.de' ],
  }

  nginx::resource::location { 'puppetboard.go2tech.de/ .php':
    vhost                => 'puppetboard.go2tech.de',
    auth_basic           => 'Puppetboard',
    auth_basic_user_file => '/data/www/puppetboard.go2tech.de/access.htpasswd',
    location             => '/',
    uwsgi                => '188.68.49.74:3032',
  }
}
