# Manages jenkins.
# Currently only one master is managed by this class,
# without the possibility to add slaves to it.
# Jobs will be managed by the jenkins job builder and not
# through this class.
# Currently, plugins are also not managed by this class.
class jenkins (
  $jenkins_home = '/data/jenkins',
) {
  # This will be our jenkins home
  file { $jenkins_home:
    ensure => 'directory',
    owner  => 'jenkins',
    group  => 'jenkins',
    mode   => '0755',
  }

  package { 'jenkins':
    ensure => 'present',
  }

  service { 'jenkins':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['jenkins'],
  }

  file { '/etc/default/jenkins':
    ensure  => 'present',
    content => template('jenkins/jenkins.default.erb'),
    group   => 'root',
    owner   => 'root',
    mode    => '0644',
    notify  => Service['jenkins'],
  }

  include role::nginx::jenkins_go2tech
}
