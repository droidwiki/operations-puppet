# Configures a mariadb role to be a slave server
class role::mariadb::slave {
  class {'::mysql::server':
    package_name     => 'mariadb-server',
    service_name     => 'mysql',
    override_options => {
      mysqld      => {
        'pid-file'     => '/var/run/mysqld/mysqld.pid',
        'datadir'      => '/data/mariadb/datadir',
        'bind-address' => $facts['networking']['interfaces']['eth1']['ip'],
        'server-id'    => $facts['mysql_server_id'],
        'relay-log'    => 'mysql-relay-bin',
        'read-only'    => '1'
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
