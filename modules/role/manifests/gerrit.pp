# This class reflects the puppetized part of the
# installation of a gerrit server
class role::gerrit {
  firewall { '200 accept outgoing gerrit traffic':
    proto  => 'tcp',
    chain  => 'OUTPUT',
    dport  => '29418',
    action => 'accept',
  }

  firewall { '201 accept incoming gerrit traffic':
    proto  => 'tcp',
    sport  => '29418',
    action => 'accept',
  }
}
