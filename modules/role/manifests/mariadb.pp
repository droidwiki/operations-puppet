# Manages automysqlbackup for now, will manage
# mariadb in the future.
class role::mariadb(
  $isslave = false,
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

  apt::key { 'mariadb_xenial_nix':
    id     => '177F4010FE56CA3336300305F1656F24C74CD1D8',
    server => 'hkp://keyserver.ubuntu.com:80',
  }

  apt::source { 'mariadb':
    location => 'http://mirrors.n-ix.net/mariadb/repo/10.4/ubuntu',
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
    class { 'role::mariadb::slave': }
  }
}
