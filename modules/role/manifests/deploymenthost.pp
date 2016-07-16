# class that represents settings for a deployment
# host (from where mediawiki code is being prepated
# for deployment and deployed)
class role::deploymenthost {
  firewall { '800 allow connections through git:// protocol':
    dport  => 9418,
    proto  => 'tcp',
    chain  => 'OUTPUT',
    action => 'accept',
  }

  package { 'git':
    ensure => present,
  }

  package { 'rsync':
    ensure => present,
  }
}
