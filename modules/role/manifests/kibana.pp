# Manages kibana and the kibana nginx host
class role::kibana {
  class { 'kibana':
    ensure => '6.2.4',
    config => {
      'server.host' => '0.0.0.0',
    }
  }
}
