class droidwiki::iptables(
  Boolean $ismailserver = false,
  Boolean $irc_out = false,
  Boolean $isjenkinshost = false,
) {
  file { '/etc/iptables.local':
    ensure => file,
    content => template('droidwiki/iptables.local.erb'),
  }
}
