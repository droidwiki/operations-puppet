# Installs aws cli and manages a script used to
# sync backup files to s3
class role::backup_s3_sync {
  class { 'awscli': }
  awscli::profile { 'backups':
    aws_region            => 'eu-west-1',
    aws_access_key_id     => hiera( 'backup_s3_sync::aws_access_key_id' ),
    aws_secret_access_key => hiera( 'backup_s3_sync::aws_secret_access_key' )
  }
}
