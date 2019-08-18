# Helper for docker hosted elasticsearch
class role::elasticsearch {
  firewall { '899 accept outgoing requests to elasticsearch':
    chain  => 'OUTPUT',
    proto  => 'tcp',
    source => '172.16.0.2/32',
    dport  => '9200',
    action => 'accept',
  }
}
