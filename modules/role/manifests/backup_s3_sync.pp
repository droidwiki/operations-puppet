# Installs aws cli and manages a script used to
# sync backup files to s3
class role::backup_s3_sync {
  class { 'awscli': }
  awscli::profile { 'backups':
    profile_name          => 'backups',
    aws_region            => 'eu-west-1',
    aws_access_key_id     => hiera( 'backup_s3_sync::aws_access_key_id' ),
    aws_secret_access_key => hiera( 'backup_s3_sync::aws_secret_access_key' )
  }

  file { '/data/backup/sync_backups.sh':
    mode   => '0755',
    group  => 'root',
    owner  => 'root',
    source => 'puppet:///modules/role/sync_backups.sh'
  }

  file { '/var/log/s3_sync':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }

  file { '/etc/logrotate.d/s3_sync':
    content => template('role/s3_sync.logrotate.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
  }

  cron { 'sync_backups':
    ensure   => present,
    command  => '/data/backup/sync_backups.sh > /var/log/s3_sync/out.log',
    user     => 'root',
    hour     => '0',
    minute   => '0',
    monthday => '1-31/2',
  }
}
