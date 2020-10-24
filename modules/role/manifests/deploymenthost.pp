# class that represents settings for a deployment
# host (from where mediawiki code is being prepated
# for deployment and deployed)
class role::deploymenthost {
  package { 'rsync':
    ensure => present,
  }
}
