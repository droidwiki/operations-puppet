class role::gmond {
	# unicast
	$udp_recv_channel = []
	$udp_send_channel = [
		{ port => 8649, host => 'puppet', ttl => 2 },
	]
	$tcp_accept_channel = []
	class{ 'ganglia::gmond':
		globals_deaf                   => 'yes',
		globals_host_dmax              => '691200',
		globals_send_metadata_interval => '60',
		cluster_name                   => 'go2tech.de',
		cluster_owner                  => 'go2tech.de',
		cluster_url                    => 'www.droidwiki.de',
		udp_recv_channel               => $udp_recv_channel,
		udp_send_channel               => $udp_send_channel,
		tcp_accept_channel             => $tcp_accept_channel,
	}
}
