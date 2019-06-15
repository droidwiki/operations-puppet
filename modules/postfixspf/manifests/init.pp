# Install and configure the postfix SPF check client
class postfixspf {
  package { 'postfix-policyd-spf-python':
    ensure => 'present',
  }
}
