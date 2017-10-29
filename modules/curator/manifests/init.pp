# Installs and manages the elasticsearch-curator tool
class curator(
  $hosts = [ '127.0.0.1' ],
) {
  apt::source { 'elasticsearch_curtaor':
    comment      => 'This is the Elasticsearch Curator apt repository',
    location     => 'http://packages.elastic.co/curator/5/debian',
    release      => 'stable',
    architecture => 'amd64',
    repos        => 'main',
    key          => {
      'id'     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
      'server' => 'pgp.mit.edu',
    },
    include      => {
      'deb' => true,
    },
  }

  package { 'elasticsearch-curator':
    ensure => present,
  }

  file { '/etc/curator/':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
  }

  curator::config {
    'config':
      content => template('curator/config.yaml.erb');
    'disable-shard-allocation':
      source => 'puppet:///modules/curator/disable-shard-allocation.yaml';
    'enable-shard-allocation':
      source => 'puppet:///modules/curator/enable-shard-allocation.yaml';
  }
}
