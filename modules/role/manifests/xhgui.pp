# Role for go2tech.de/xhgui
# Should be used in combination with role::profilinghost
class role::xhgui {
  vcsrepo { '/data/xhprof':
    ensure   => 'latest',
    owner    => 'www-data',
    group    => 'www-data',
    provider => git,
    require  => [ Package['git'] ],
    source   => 'https://gerrit.wikimedia.org/r/operations/software/xhprof',
    revision => 'wmf_deploy',
  } ->

  file { '/data/xhprof/profiles':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  vcsrepo { '/data/xhgui':
    ensure   => 'latest',
    owner    => 'www-data',
    group    => 'www-data',
    provider => git,
    require  => [ Package['git'] ],
    source   => 'https://gerrit.wikimedia.org/r/operations/software/xhgui',
    revision => 'wmf_deploy',
  } ->

  file { '/data/xhgui/cache':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  } ->

  droidwiki::nginx::hhvmvhost { 'xhgui.go2tech.de':
    vhost_url => 'xhgui.go2tech.de',
    www_root  => '/data/xhgui/webroot',
  }

  nginx::resource::location { 'xhgui.go2tech.de/':
    vhost               => 'xhgui.go2tech.de',
    location            => '/',
    location_custom_cfg => {
      'try_files' => '$uri $uri/ /index.php?$uri&$args',
    }
  }
}
