# This role ensures, that the mediawiki
# directory in the /data partition is
# present and setup correctly.
class role::mediawiki{
  file{ '/data/mediawiki':
    ensure => 'directory',
    mode   => '0775',
    owner  => 'florian',
    group  => 'florian',
  }

  file{ '/data/mediawiki/main':
    ensure => 'directory',
    mode   => '0775',
    owner  => 'florian',
    group  => 'florian',
  }

  # default location for configuration files
  # related to mediawiki services
  file{ '/etc/mediawiki':
    ensure => 'directory',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  # default location for log files
  #related to mediawiki services
  file { '/var/log/mediawiki':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }
}
