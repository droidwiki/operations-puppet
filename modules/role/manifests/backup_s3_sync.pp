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
}
