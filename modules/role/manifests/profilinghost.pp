# Configuration to save MediaWiki profiling data on this server
class role::profilinghost {
  # mongodb is used to store profiling data
  class {'::mongodb::server':
    ensure => 'purged',
  }
}
