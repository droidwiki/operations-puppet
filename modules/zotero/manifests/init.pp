# Manages an installation of the zotero translation server
class zotero {
  $log_dir = '/var/log/zotero'
  $base_path = '/data/zotero'

  file { $log_dir:
    ensure => directory,
    owner  => 'zotero',
    group  => 'zotero',
    mode   => '0755',
    before => Service['zotero'],
  }

  group { 'zotero':
    ensure => present,
    system => true,
  }

  user { 'zotero':
    gid    => 'zotero',
    home   => '/nonexistent',
    shell  => '/bin/false',
    system => true,
  }

  file { '/data/zotero/':
    ensure => 'directory',
    owner  => 'zotero',
    group  => 'zotero',
    mode   => '0644',
  }

  vcsrepo { "$base_path/translation-server":
    ensure   => present,
    provider => git,
    owner    => 'zotero',
    group    => 'zotero',
    source   => 'https://github.com/wikimedia/mediawiki-services-zotero-translation-server',
  }

  vcsrepo { "$base_path/translators":
    ensure   => present,
    provider => git,
    owner    => 'zotero',
    group    => 'zotero',
    source   => 'https://github.com/wikimedia/mediawiki-services-zotero-translators',
  }

  file { '/usr/lib/xulrunner-24.0':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }

  file { "$base_path/install_xulrunner.sh":
    ensure  => 'present',
    content => template('zotero/install_xulrunner.sh.erb'),
    owner   => 'zotero',
    group   => 'zotero',
    mode    => '0755',
  }

  exec { 'install-xulrunner-24.0':
    refreshonly => true,
    command     => '/data/zotero/install_xulrunner.sh',
    cwd         => '/usr/lib/xulrunner-24.0',
    subscribe   => File['/usr/lib/xulrunner-24.0'],
    require     => File["$base_path/install_xulrunner.sh"],
  }

  file { '/etc/zotero':
    ensure => directory,
  }

  file { '/etc/zotero/defaults.js':
    ensure  => present,
    content => template('zotero/defaults.js.erb'),
    require => Vcsrepo['/data/zotero/translation-server'],
    notify  => Service['zotero'],
  }

  file { '/etc/init/zotero.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('zotero/upstart.conf.erb'),
    notify  => Service['zotero'],
  }

 service { 'zotero':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    provider   => 'upstart',
    require    => File['/etc/init/zotero.conf'],
    subscribe  => File['/etc/init/zotero.conf'],
  }
}
