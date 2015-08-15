class role::mediawiki{
	include role::nginx::droidwiki
	include role::hhvm

	file{ '/data/mediawiki':
		ensure => 'directory',
		mode => 0775,
		owner => florian,
		group => florian,
	}
}

