class role::hhvm {
	include apt
	apt::key { 'hhvm':
		id	=> '0x5a16e7281be7a449',
		server	=> 'hkp://keyserver.ubuntu.com:80',
	}

	apt::source { 'hhvm':
		comment  => 'Repo for hhvm package',
		location => 'http://dl.hhvm.com/ubuntu',
		release  => 'trusty',
		repos	 => 'main',
	}

	# Derive HHVM's thread count by taking the smallest of:
	#  - the memory of the system divided by a typical thread memory allocation
	#  - processor count * 4 (we have hyperthreading)
	$max_threads = min(
		floor(to_bytes($::memorytotal) / to_bytes('120M')),
		$::processorcount*4)

	class { '::hhvm':
		fcgi_settings => {
			hhvm => {
				xenon          => {
					period => 600,
				},
				error_handling => {
					call_user_handler_on_fatals => true,
				},
				server         => {
					source_root           => '/data/mediawiki/main',
					#error_document500     => '/data/mediawiki/hhvm-fatal-error.php',
					#error_document404     => '/data/mediawiki/w/404.php',
					#request_init_document => '/data/mediawiki/wmf-config/HHVMRequestInit.php',
					#thread_count          => $max_threads,
					ip                    => '127.0.0.1',
				},
				pcre_cache_type => 'lru',
			},
		},
	}
} 
