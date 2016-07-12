# A role that ensures, that ganglia (both gmetad
# and ganglia-monitor) is installed and correctly
# configured to send the data to go2tech.de
class role::ganglia(
  Boolean $gmetad = false,
) {
  if ($gmetad) {
    $udp_recv_channel = [
      { port => 8649 },
    ]
    $tcp_accept_channel = [
      { port => 8649 },
    ]
  } else {
    $udp_recv_channel = []
    $tcp_accept_channel = []
  }

  $udp_send_channel = [
    { port => 8649, host => 'puppet', ttl => 2 },
  ]
  class{ 'ganglia::gmond':
    globals_deaf                   => 'no',
    globals_host_dmax              => '0',
    globals_send_metadata_interval => '60',
    cluster_name                   => 'go2tech.de',
    cluster_owner                  => 'DroidWiki',
    cluster_url                    => 'droidwiki.de',
    udp_recv_channel               => $udp_recv_channel,
    udp_send_channel               => $udp_send_channel,
    tcp_accept_channel             => $tcp_accept_channel,
  }

  if ($gmetad) {
    $clusters = [
      {
        name     => 'go2tech.de',
        polling_interval => 15,
        address  => 'localhost',
      },
    ]
    class { 'ganglia::gmetad':
      clusters      => $clusters,
      all_trusted   => false,
      trusted_hosts => [],
    }
  }
}
