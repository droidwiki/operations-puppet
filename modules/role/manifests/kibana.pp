# Manages kibana and the kibana nginx host
class role::kibana {
  class { 'kibana':
    config => {
      'server.host' => '0.0.0.0',
    }
  }
}
