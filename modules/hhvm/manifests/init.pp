# hhvm installation
class hhvm {
  apt::source { 'hhvm':
    location => 'http://dl.hhvm.com/ubuntu',
    repos    => 'main',
    include  => {
      'src' => false,
      'deb' => true,
    },
    key      => {
      'id'     => '36AEF64D0207E7EEE352D4875A16E7281BE7A449',
    },
    notify   => Exec[ 'apt_update' ]
  }

  package { 'hhvm':
    ensure => 'present',
    notify => Exec[ 'update-rc.d hhvm defaults' ],
  }

  exec { 'update-rc.d hhvm defaults':
    refreshonly => true,
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:',
  }
}
