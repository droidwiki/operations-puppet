# A role for the puppetmaster(s). Ensures,
# that puppet-lint is installed, only.
# FIXME: Will probably overlap with a
# jenkins role, later.
class role::puppetmaster {
  package { 'puppet-lint':
    ensure   => '1.1.0',
    provider => 'gem',
  }
}
