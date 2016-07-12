# Manages the iptables rules for the servers
# The rules are very restrictive, which means, that
# any traffic, which is not explicitly allowed, is
# dropped (except internal traffic).
class droidwiki::iptables(
  Boolean $ismailserver = false,
  Boolean $irc_out = false,
  Boolean $isjenkinshost = false,
) {
  file { '/etc/iptables.local':
    ensure  => file,
    content => template('droidwiki/iptables.local.erb'),
  }
}
