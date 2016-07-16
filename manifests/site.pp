# site.pp
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

node 'puppet.speedport.ip' {
  # include droidwiki::default
  include role::symlinkdata
  include role::webserver
  include hhvm
  include role::nginx::go2tech
  include role::nginx::blog_go2tech
  include role::nginx::jenkins_go2tech
  include role::nginx::droidwiki
  include role::nginx::ops_go2tech
  include role::nginx::dev_go2tech
  include role::nginx::ganglia_go2tech
  include role::nginx::gerrit_go2tech
  include role::nginx::git_go2tech
  include role::nginx::puppetboard_go2tech
  include role::nginx::graphite_go2tech
  include role::nginx::grafana_go2tech
}
