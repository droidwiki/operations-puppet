# Manages automysqlbackup for now, will manage
# mariadb in the future.
class role::mariadb(
  $isslave = false,
  $serverid = 1,
) {
  file { '/data/backup':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0731',
  }

  package { 'mailutils':
    ensure => 'present',
  }

  include automysqlbackup

  automysqlbackup::backup { 'automysqlbackup':
    do_monthly                   => '0',
    do_weekly                    => '0',
    mysql_dump_username          => hiera( 'automysqlbackup::backup::mysql_dump_username' ),
    mysql_dump_password          => hiera( 'automysqlbackup::backup::mysql_dump_password' ),
    mysql_dump_use_separate_dirs => 'yes',
    db_exclude                   => hiera( 'automysqlbackup::backup::db_exclude' ),
    table_exclude                => hiera( 'automysqlbackup::backup::table_exclude' ),
    mail_address                 => hiera( 'automysqlbackup::backup::mail_address' ),
    mailcontent                  => hiera( 'automysqlbackup::backup::mailcontent' ),
  }

  if ($::lsbdistcodename == 'trusty') {
    # mariadb on mirrors.n-ix.net for trusty
    apt::key { 'mariadb_trusty_nix':
      id     => '199369E5404BD5FC7D2FE43BCBCB082A1BB943DB',
      server => 'hkp://keyserver.ubuntu.com:80',
    }
  } else {
    # mariadb on mirrors.n-ix.net for xenial
    apt::key { 'mariadb_xenial_nix':
      id     => '177F4010FE56CA3336300305F1656F24C74CD1D8',
      server => 'hkp://keyserver.ubuntu.com:80',
    }
  }

  apt::source { 'mariadb':
    location => 'http://mirrors.n-ix.net/mariadb/repo/10.2/ubuntu',
    release  => $::lsbdistcodename,
    repos    => 'main',
    key      => {
      id     => '199369E5404BD5FC7D2FE43BCBCB082A1BB943DB',
      server => 'hkp://keyserver.ubuntu.com:80',
    },
    include  => {
      src => false,
      deb => true,
    },
  }

  if ($isslave) {
    class {'::mysql::server':
      package_name     => 'mariadb-server',
      service_name     => 'mysql',
      override_options => {
        mysqld      => {
          'pid-file'        => '/var/run/mysqld/mysqld.pid',
          'datadir'         => '/data/mariadb/datadir',
          'bind-address'    => $facts['networking']['ip'],
          'server-id'       => $facts['mysql_server_id'],
          'replicate-do-db' => ['droidwikiwiki', 'devwiki', 'graphite', 'missionrhode', 'opswiki', 'reviewdb', 'vmail', 'wordpress', 'datawiki', 'endroidwikiwiki'],
          'relay-log'       => 'mysql-relay-bin',
          'read-only'       => '1'
        },
        mysqld_safe => {
          'socket' => '/var/run/mysqld/mysqld.sock',
          'nice'   => '0',
        },
      }
    }

    class {'::mysql::client':
      package_name    => 'mariadb-client',
      bindings_enable => true,
    }

    Apt::Source['mariadb']
    ~> Class['apt::update']
    -> Class['::mysql::server']
    -> Class['::mysql::client']

    file { '/data/mariadb':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }

    file { '/data/mariadb/slave_running.sh':
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0744',
      source => 'puppet:///modules/role/mariadb/slave_running.sh',
    }

    cron { 'slave_running':
      ensure  => 'present',
      command => '/data/mariadb/slave_running.sh',
      minute  => '*/1',
    }

    monit::service { 'mariadb_slave': }
  }
}
