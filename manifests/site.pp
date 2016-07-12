node 'old_example' {
  include role::mediawiki
  include role::nginx::droidwiki
}

node 'eclair.dwnet' {
  include droidwiki::default
  include role::puppetmaster
  class { 'role::ganglia':
    gmetad => true,
  }

  class { 'droidwiki::iptables':
    ismailserver => true,
    irc_out => true,
    isjenkinshost => true,
  }
}

node 'donut.dwnet' {
  include droidwiki::default
  include droidwiki::iptables
  include role::ganglia
}
