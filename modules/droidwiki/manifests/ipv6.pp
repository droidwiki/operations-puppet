# Configrured IPv6 (without addresses on the interface)
class droidwiki::ipv6 {
  file { '/etc/sysctl.d/50-IPv6.conf':
    source => 'puppet:///modules/droidwiki/50-IPv6.conf',
  }

  exec { '/sbin/sysctl --system':
    command     => '/sbin/sysctl --system',
    subscribe   => [
      File['/etc/sysctl.d/50-IPv6.conf'],
    ],
    refreshonly => true,
  }
}
