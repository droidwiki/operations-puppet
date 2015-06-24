class role::mediawiki{
	file{ '/data/mediawiki':
		ensure => 'directory',
		mode => 0775,
		owner => florian,
		group => florian,
	}
}

