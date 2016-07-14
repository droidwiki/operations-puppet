# ensures, that the rc.local is managed
class droidwiki::rclocal {
  file { '/etc/rc.local':
    ensure  => file,
    content => template('droidwiki/rc.local.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
}
