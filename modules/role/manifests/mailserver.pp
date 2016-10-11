# Generic class for a mailserver installation
# currently only handles the firewall rules
class role::mailserver {
  firewall { '400 accept incoming mail traffic':
    proto  => 'tcp',
    dport  => ['25', '143', '587', '993'],
    action => 'accept',
  }

  firewall { '401 accept outgoing mail traffic':
    proto  => 'tcp',
    dport  => ['25', '143', '587', '993'],
    chain  => 'OUTPUT',
    action => 'accept',
  }

  include postfix
}
