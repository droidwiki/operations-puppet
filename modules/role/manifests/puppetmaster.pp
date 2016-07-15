# A role for the puppetmaster(s). Ensures,
# that puppet-lint is installed, only.
# FIXME: Will probably overlap with a
# jenkins role, later.
class role::puppetmaster {
  package { 'puppet-lint':
    ensure   => '1.1.0',
    provider => 'gem',
  }

  class { 'puppetdb':
    listen_port     => 8083,
    ssl_listen_port => 8084,
  }
  class { 'puppetdb::master::config':
    puppetdb_port               => 8084,
    puppetdb_soft_write_failure => true,
    enable_reports              => true,
    manage_config               => true,
    manage_report_processor     => true,
  }
}
