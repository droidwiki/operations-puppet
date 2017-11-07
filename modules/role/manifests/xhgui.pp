# Role for go2tech.de/xhgui
# Should be used in combination with role::profilinghost
class role::xhgui {
  file { '/data/xhprof':
    ensure => 'absent',
    force  => true,
  }

  file { '/data/xhgui':
    ensure => 'absent',
    force  => true,
  }

  droidwiki::nginx::hhvmvhost { 'xhgui.go2tech.de':
    ensure    => 'absent',
    vhost_url => 'xhgui.go2tech.de',
  }

  nginx::resource::location { 'xhgui.go2tech.de/':
    ensure              => 'absent',
    vhost               => 'xhgui.go2tech.de',
    location            => '/',
    location_custom_cfg => {
      'try_files' => '$uri $uri/ /index.php?$uri&$args',
    }
  }
}
