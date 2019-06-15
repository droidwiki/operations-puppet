# Generic class for a mailserver installation
# currently only handles the firewall rules
class role::mailserver {
  firewall { '400 accept incoming mail traffic':
    proto  => 'tcp',
    dport  => ['25', '143', '587', '993'],
    action => 'accept',
  }

  firewall { '400 accept incoming mail traffic IPv6':
    proto    => 'tcp',
    dport    => ['25', '143', '587', '993'],
    action   => 'accept',
    provider => 'ip6tables',
  }

  firewall { '401 accept outgoing mail traffic':
    proto  => 'tcp',
    dport  => ['25', '143', '587', '993'],
    chain  => 'OUTPUT',
    action => 'accept',
  }

  firewall { '401 accept outgoing mail traffic IPv6':
    proto    => 'tcp',
    dport    => ['25', '143', '587', '993'],
    chain    => 'OUTPUT',
    action   => 'accept',
    provider => 'ip6tables',
  }

  include ::opendkim
  include postfixspf
  include postsrsd
  include postfix

  $postfixcertcheck = hiera('monit::postfix::certcheck', {})
  create_resources('monit::certcheck', $postfixcertcheck)
}
