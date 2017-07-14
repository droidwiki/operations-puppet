# Installs and configures mailgraph
class mailgraph {
  package { 'mailgraph':
    ensure => 'present',
  }
}
