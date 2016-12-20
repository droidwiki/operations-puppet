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

  file { '/data/log':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0765',
  }

  # default location for log files
  # related to mediawiki services
  file { '/data/log/mediawiki':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    # FIXME: 765 because otherwise deployments would fail as they're done
    # with the user who does the deployment (this should be changed)
    mode   => '0766',
  }
}
