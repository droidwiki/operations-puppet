# Mostly for test hosts, symlink /data
# to /var/data.
class role::symlinkdata {
  file { '/var/data':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/data':
    ensure => 'link',
    target => '/var/data',
  }
}
