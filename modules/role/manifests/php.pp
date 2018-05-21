# Installs and configures a PHP runtime on the
# server.
class role::php(
  $php_version = '7.2',
) {
  # wikidiff2 apt repository
  apt::source { 'ppa-floriansw-droidwiki':
    location     => 'http://ppa.launchpad.net/floriansw/droidwiki/ubuntu',
    release      => 'bionic',
    repos        => 'main',
    key          => {
      'id' => '6F80C4BEE4B4D93724159E10D56BC20EA6DCA5A9',
    },
    architecture => 'amd64',
  }

  class { '::php::globals':
    php_version => $php_version,
  }
  -> class { '::php':
    manage_repos => true,
    fpm          => true,
    dev          => true,
    composer     => true,
    pear         => true,
    phpunit      => false,

    settings     => {
      'PHP/upload_max_filesize' => '100M',
      'PHP/post_max_size'       => '100M',
    },

    extensions   => {
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
        zend     => true,
      },
      json      => {
        provider => 'apt',
      },
      mbstring  => {
        provider => 'apt',
      },
      redis     => {
        provider       => 'apt',
        package_prefix => 'php-',
      },
      mysql     => {
        provider => 'apt',
        so_name  => 'mysqli',
      },
      curl      => {
        provider => 'apt',
      },
      ldap      => {
        provider => 'apt',
      },
      wikidiff2 => {
        provider       => 'apt',
        package_prefix => 'php-',
      }
    },
    require      => Apt::Source['ppa-floriansw-droidwiki'],
  }

  if $facts['os']['name'] == 'Ubuntu' and versioncmp($facts['os']['release']['full'], '16.04') < 0 {
    php::extension { 'xml': }
  }

  monit::service { "php${php_version}-fpm": }
}
