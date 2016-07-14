# IRC bot role, which makes sure, an irc bot can work
class role::ircbot {
  firewall { '500 accept outgoing irc traffic':
    proto  => 'tcp',
    dport  => '6697',
    chain  => 'OUTPUT',
    action => 'accept',
  }
}
