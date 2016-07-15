node 'old_example' {
  include role::mediawiki
  include role::nginx::droidwiki
}

node 'eclair.dwnet' {
  include droidwiki::default
  include role::gerrit
  include role::webserver
  include role::mailserver
  include role::ircbot
  include role::jenkinsmaster
  include role::puppetmaster
  include role::deploymenthost

  class { 'role::puppetboard':
    puppetboard_url => 'puppetboard.go2tech.de',
  }

  class { 'role::ganglia':
    gmetad => true,
  }
}

node 'donut.dwnet' {
  include droidwiki::default
  include role::webserver
  include role::ganglia
}
