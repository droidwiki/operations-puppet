# site.pp
node 'eclair.dwnet' {
  include droidwiki::default
  include role::gerrit
  include role::webserver
  include role::mailserver
  include role::ircbot
  include role::jenkinsmaster
  include role::puppetmaster
  include role::deploymenthost

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

  include role::puppetboard

  include role::ganglia
}

node 'donut.dwnet' {
  include droidwiki::default
  include role::webserver
  include role::ganglia

  include role::nginx::droidwiki
  include role::nginx::data_droidwiki
}
