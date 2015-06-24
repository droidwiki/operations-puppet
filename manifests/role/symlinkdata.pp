class role::symlinkdata{
	file{ '/var/data':
		ensure => directory,
		mode => 775,
		owner => florian,
		group => florian,
	}

	file{ '/data':
		ensure => link,
		target => '/var/data',
	}
}
