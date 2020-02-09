# This role ensures, that the mediawiki
# directory in the /data partition is
# present and setup correctly.
class role::mediawiki(
  $isslave = false,
) {
  file{ '/data/mediawiki':
    ensure => 'directory',
    mode   => '0775',
    owner  => 'www-data',
    group  => 'www-data',
  }

  file{ '/data/mediawiki/main':
    ensure => 'directory',
    mode   => '0775',
    owner  => 'www-data',
    group  => 'www-data',
  }

  # default location for configuration files
  # related to mediawiki services
  file{ '/etc/mediawiki':
    ensure => 'directory',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { '/data/log':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  # default location for log files
  # related to mediawiki services
  file { '/data/log/mediawiki':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0777',
  }

  file { '/etc/logrotate.d/mediawiki':
    content => template('role/mediawiki.logrotate.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
  }

  if ($isslave) {
    $wikis = [
      'droidwikiwiki',
      'datawiki',
      'opswiki',
    ]

    $wikis.each |Integer $index, String $dbname| {
      cron { "cron-updatespecialpages-${dbname}":
        command  => "docker run -it --rm --net=host -u www-data:www-data -v /data:/data -w /data/mediawiki droidwiki/php-fpm:7.4 php mw-config/mw-config/multiversion/MWScript.php updateSpecialPages.php --wiki=${dbname} --override  > /data/log/mediawiki/updateSpecialPages-${dbname}.log 2>&1",
        user     => 'root',
        monthday => [8, 22],
      }
    }
  }

  # Image rendering
  package { 'imagemagick':
    ensure => present,
  }
}
