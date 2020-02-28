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

  file { '/usr/bin/php':
    source => 'puppet:///modules/role/php',
    owner  => 'root',
    group  => 'root',
    mode   => '755',
  }

  if ($isslave) {
    $wikis = [
      'droidwikiwiki',
      'datawiki',
      'opswiki',
      'endroidwikiwiki',
    ]

    $wikis.each |Integer $index, String $dbname| {
      cron { "cron-updatespecialpages-${dbname}":
        command  => "/usr/bin/php /data/mediawiki/mw-config/mw-config/multiversion/MWScript.php updateSpecialPages.php --wiki=${dbname} --override  > /data/log/mediawiki/updateSpecialPages-${dbname}.log 2>&1",
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
