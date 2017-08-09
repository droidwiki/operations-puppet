# Manages kibana and the kibana nginx host
class role::kibana {
  package { 'kibana':
    ensure => '5.5.1',
  }

  service { 'kibana':
    ensure  => 'running',
    require => Package['kibana'],
  }

  include role::nginx::kibana_go2tech
}
