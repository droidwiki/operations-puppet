# ES role, which maintains one elasticsearch instance.
class role::elasticsearch {
  class { 'elasticsearch':
    version => '2.4.1'
  }

  elasticsearch::instance { 'es-01':
    config        => {
      'network.host' => '0.0.0.0',
    },
    init_defaults => { },
    datadir       => '/data/elasticsearch/',
  }
}
