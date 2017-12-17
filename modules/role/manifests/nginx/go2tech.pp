# Class for go2tech.de nginx configurations
class role::nginx::go2tech {
  file { '/data/www/go2tech.de':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/www/go2tech.de/go2tech.de.crt':
    ensure => absent,
  }

  file { '/data/www/go2tech.de/public_html':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  package { 'fcgiwrap':
    ensure => 'present',
  }

  service { 'fcgiwrap':
    ensure  => 'running',
    require => Package['fcgiwrap'],
  }

  file { '/data/www/go2tech.de/public_html/cgi-bin':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/www/go2tech.de/public_html/cgi-bin/mailgraph.cgi':
    ensure => 'link',
    target => '/usr/lib/cgi-bin/mailgraph.cgi',
  }

  nginx::resource::vhost { '_':
    www_root             => '/data/www/go2tech.de/public_html',
    ipv6_enable          => true,
    listen_options       => 'default_server',
    index_files          => [ 'missing.php' ],
    add_header           => { 'X-Delivered-By' => $facts['fqdn'] },
    use_default_location => false,
  }

  nginx::resource::location { '_ php':
    vhost    => '_',
    location => '~ \.php$',
    fastcgi  => '127.0.0.1:9000',
  }

  nginx::resource::vhost { 'go2tech.de.80':
    server_name          => [ 'go2tech.de', 'www.go2tech.de' ],
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    add_header           => {
      'X-Delivered-By' => $facts['fqdn'],
    },
    vhost_cfg_append     => {
      'return' => '301 https://$host$request_uri',
    },
    index_files          => [],
    use_default_location => false,
  }

  $sslcert = '/etc/letsencrypt/live/blog.go2tech.de-0001/fullchain.pem';
  $sslkey = '/etc/letsencrypt/live/blog.go2tech.de-0001/privkey.pem';

  nginx::resource::vhost { 'go2tech.de':
    server_name          => [ 'go2tech.de', 'bits.go2tech.de', '188.68.49.74' ],
    ipv6_enable          => true,
    ipv6_listen_options  => '',
    www_root             => '/data/www/go2tech.de/public_html',
    index_files          => [ 'index.php' ],
    listen_port          => 443,
    ssl_port             => 443,
    ssl                  => true,
    ssl_cert             => $sslcert,
    ssl_key              => $sslkey,
    ssl_dhparam          => $sslcert::params::dhparampempath,
    ssl_stapling         => true,
    ssl_stapling_verify  => true,
    http2                => on,
    add_header           => {
      'X-Delivered-By'            => $facts['fqdn'],
      'Strict-Transport-Security' => '"max-age=31536000; preload"',
    },
    vhost_cfg_append     => {
      'error_page 404' => '/404.html',
    },
    use_default_location => false,
  }

  monit::certcheck { 'go2tech.de': }

  nginx::resource::location {
    default:
      vhost    => 'go2tech.de',
      ssl      => true,
      ssl_only => true,
    ;
    'go2tech.de mail-admin':
      location => '/mail-admin',
      www_root => '/data/www/go2tech.de/mail-admin/public/',
      # The current path nginx will try to serve would be:
      #  /data/www/go2tech.de/mail-admin/public/mail-admin/build/app.css
      # which does not exist, manually rewrite the url to remove the 2nd mail-admin
      # dir
      rewrite_rules => [
        '^/mail-admin(/.*)$ $1 break',
      ],
      try_files     => [
        '$uri',
        '/mail-admin/index.php$is_args$args',
      ],
    ;
    'go2tech.de mail-admin php':
      location => '~ ^/mail-admin/index\.php(/|$)',
      www_root => '/data/www/go2tech.de/mail-admin/public/',
      fastcgi  => '127.0.0.1:9000',
      fastcgi_split_path => '^(.+\.php)(/.*)$',
      raw_prepend => [
        # The current $fastcgi_script_name is /mail-admin/index.php which does not eixst
        'if ($fastcgi_script_name ~ ^/mail-admin(/.*)$) {',
        '    set $index $1;',
        '}',
      ],
      fastcgi_param => {
        'SCRIPT_FILENAME' => '$realpath_root$index',
        'DOCUMENT_ROOT'   => '$realpath_root',
      },
      internal => true,
    ;
    'go2tech.de php':
      location => '~ \.php$',
      fastcgi  => '127.0.0.1:9000',
    ;
    'go2tech.de/webssh':
      location              => '/webssh',
      proxy                 => 'https://127.0.0.1:4200/',
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
    'go2tech.de/monit':
      location            => '/monit',
      location_custom_cfg => {
        'return' => '301 /monit/',
      },
    ;
    'go2tech.de/monit/':
      location              => '/monit/',
      rewrite_rules         => [
        '^/monit/(.*) /$1 break',
      ],
      proxy                 => 'http://127.0.0.1:2812',
      proxy_set_header      => [
        'Host $host',
        'X-Real-IP $remote_addr',
        'X-Forwarded-For $remote_addr',
      ],
      proxy_connect_timeout => '300',
    ;
    'go2tech.de/citoid/':
      location              => '/citoid/',
      proxy                 => 'http://127.0.0.1:1970/',
      proxy_set_header      => [
        'Host $host',
        'X-Real-IP $remote_addr',
        'X-Forwarded-For $remote_addr',
      ],
      proxy_connect_timeout => '300',
    ;
    'go2tech.de/cxserver/':
      location              => '/cxserver/',
      proxy                 => 'http://donut.dwnet:7232/',
      proxy_set_header      => [
        'Host $host',
        'X-Real-IP $remote_addr',
        'X-Forwarded-For $remote_addr',
      ],
      proxy_connect_timeout => '300',
    ;
    'go2tech.de/cgi-bin/':
      location => '/cgi-bin/',
      fastcgi  => 'unix:/var/run/fcgiwrap.socket',
  }
}
