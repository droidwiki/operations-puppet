# vhosts and locations for blog.go2tech.de
class role::nginx::blog_go2tech {
  file { '/data/www/blog.go2tech.de':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/www/blog.go2tech.de/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  nginx::resource::vhost { 'blog.go2tech.de':
    use_default_location => false,
    ipv6_enable          => true,
    server_name          => [ 'blog.go2tech.de' ],
    www_root             => '/data/www/blog.go2tech/public_html/',
    index_files          => [ 'index.php' ],
  }

  nginx::resource::location { 'blog.go2tech.de/':
    vhost               => 'blog.go2tech.de',
    location            => '/',
    location_custom_cfg => {
      'try_files' => '$uri $uri/ /index.php?$args',
    },
  }

  nginx::resource::location { 'blog.go2tech.de php':
    vhost    => 'blog.go2tech.de',
    location => '~ \.php$',
    fastcgi  => '127.0.0.1:9000',
  }
}
