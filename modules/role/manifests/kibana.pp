# Manages kibana and the kibana nginx host
class role::kibana {
  class { 'kibana':
    ensure => '5.5.1',
    config => {
      'server.host' => '0.0.0.0',
    }
  }
}
