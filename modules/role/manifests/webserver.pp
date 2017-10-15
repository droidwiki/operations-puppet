# Generic class for a webserver installation
# currently only handles the firewall rules
class role::webserver {
  firewall { '300 accept incoming http traffic':
    proto  => 'tcp',
    dport  => '80',
    action => 'accept',
  }

  firewall { '301 accept outgoing http traffic':
    proto  => 'tcp',
    dport  => '80',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '302 accept outgoing http traffic':
    proto  => 'tcp',
    sport  => '80',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '303 accept incoming https traffic':
    proto  => 'tcp',
    dport  => '443',
    action => 'accept',
  }

  firewall { '304 accept outgoing https traffic':
    proto  => 'tcp',
    dport  => '443',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '305 accept outgoing https traffic':
    proto  => 'tcp',
    sport  => '443',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  # deploy our own key exchange parameter for every webserver host
  class { 'sslcert::dhparam': }

  # install nginx, but don't configure any hosts
  class { 'nginx':
    manage_repo    => true,
    package_source => 'nginx-mainline',
  }

  package { 'hhvm':
    ensure => 'absent',
  }

  class { '::php::globals':
    php_version => '7.0',
  }
  -> class { '::php':
    manage_repos => true,
    fpm          => true,
    dev          => true,
    composer     => true,
    pear         => true,
    phpunit      => false,

    extensions => {
      xml  => {},
      imagick   => {
        provider       => 'apt',
        package_prefix => 'php-',
      },
      memcached => {
        provider       => 'apt',
        package_prefix => 'php-',
      },
      # needed by WodPress with Memcache object cache
      memcache  => {
        provider       => 'apt',
        package_prefix => 'php-',
      },
      apcu      => {
        provider       => 'apt',
        package_prefix => 'php-',
        settings       => {
          'apc/stat'       => '1',
          'apc/stat_ctime' => '1',
        },
        sapi           => 'fpm',
      },
      opcache   => {
        provider => 'apt',
      },
      json      => {
        provider => 'apt',
      },
      mbstring  => {
        provider => 'apt',
      },
      redis     => {
        provider => 'apt',
        package_prefix => 'php-',
      },
      mysql     => {
        provider => 'apt',
      },
      curl      => {
        provider => 'apt',
      },
    },
  }

  monit::service { 'nginx': }
  monit::service { 'php7.0-fpm': }

  file { '/data/www':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0775',
  }

  file { '/etc/ssl/certs/startssl.root.intermediate.pem':
    ensure => 'absent',
  }
}
