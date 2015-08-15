import "role/*"

class standard{
	user { 'florian' : 
		name      => 'florian',
		ensure    => present, 
		shell     => '/bin/bash',
		password  => '',
		home      => '/home/florian',
		system    => true,                      #Makes sure user has uid less than 500
		managehome => true,
	}
}

node 'puppetclient' {
	include standard
	include role::gmond
	include role::symlinkdata
	include role::mediawiki
}
