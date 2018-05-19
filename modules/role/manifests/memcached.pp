# Installs and configured memcached on the host
class role::memcached {
  group { 'memcache':
    ensure => present,
    system => true,
  }

  user { 'memcache':
    gid    => 'memcache',
    home   => '/nonexistent',
    shell  => '/bin/false',
    system => true,
  }

  class { 'memcached':
    listen_ip => '0.0.0.0',
    user      => 'memcache',
  }
}
