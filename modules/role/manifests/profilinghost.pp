# Configuration to save MediaWiki profiling data on this server
class role::profilinghost {
  # mongodb is used to store profiling data
  class {'::mongodb::server':
    dbpath  => '/data/mongodb',
    bind_ip => [ '0.0.0.0' ],
  }

  mongodb::db { 'xhprof':
    user          => 'xhprof',
    password_hash => 'd83610e7d5f7e444f227ec98a658558a',
  }
}
