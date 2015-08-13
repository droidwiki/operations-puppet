class role::nginx {
	
	class droidwiki {
		include role::nginx::ssl
		nginx::site{ 'droidwiki.de':
			content => template('droidwiki/droidwiki.conf.erb')
		}
	}

	class ssl {
		include nginx::ssl
	}
}
