class role::puppetmaster {
	package { 'puppet-lint':
		ensure => 'installed',
	}
}
