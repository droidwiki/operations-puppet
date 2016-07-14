# Role to describe a jenkins master
class role::jenkinsmaster {
  firewall { '600 accept outgoing jenkins dns multicast traffic':
    proto  => 'udp',
    dport  => '5353',
    chain  => 'OUTPUT',
    action => 'accept',
  }
}
