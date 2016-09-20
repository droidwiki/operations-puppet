# Manages automysqlbackup for now, will manage
# mariadb in the future.
class role::mariadb {
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
    do_monthly          => '0',
    do_weekly           => '0',
    mysql_dump_username => hiera( 'automysqlbackup::backup::mysql_dump_username' ),
    mysql_dump_password => hiera( 'automysqlbackup::backup::mysql_dump_password' ),
    db_exclude          => hiera( 'automysqlbackup::backup::db_exclude' ),
    table_exclude       => hiera( 'automysqlbackup::backup::table_exclude' ),
    mail_address        => hiera( 'automysqlbackup::backup::mail_address' ),
    mailcontent         => hiera( 'automysqlbackup::backup::mailcontent' ),
  }
}
