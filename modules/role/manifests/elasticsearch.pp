# ES role, which maintains one elasticsearch instance.
# This class also manages the elasticsearch repository for
# apt, so no other class needs to add it (as long as the wanted
# package is in the https://artifacts.elastic.co/packages/5.x/apt
# repository)
class role::elasticsearch {
  class { 'elasticsearch':
    manage_repo  => true,
    repo_version => '5.x',
    version      => '5.1.2',
    jvm_options => [
      '-Xms1500m',
      '-Xmx1500m',
    ],
  }

  elasticsearch::instance { 'es-01':
    config        => {
      'network.host'             => '0.0.0.0',
    },
    init_defaults => {
      'MAX_LOCKED_MEMORY' => '100000',
      'ES_JAVA_OPTS'      => '-server',
    },
    datadir       => '/data/elasticsearch/',
  }
}
