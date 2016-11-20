# site.pp
node 'eclair.dwnet' {
  include droidwiki::default
  include monit
  include role::gerrit
  include role::mariadb
  include role::webserver
  include role::mediawiki
  include role::mailserver
  include role::ircbot
  include role::jenkinsmaster
  include role::puppetmaster
  include role::deploymenthost
  include certbot

  include role::nginx::go2tech
  include role::nginx::www_go2tech
  include role::nginx::blog_go2tech
  include role::nginx::jenkins_go2tech
  include role::nginx::ops_go2tech
  include role::nginx::dev_go2tech
  include role::nginx::ganglia_go2tech
  include role::nginx::gerrit_go2tech
  include role::nginx::git_go2tech
  include role::nginx::puppetboard_go2tech
  include role::nginx::graphite_go2tech
  include role::nginx::grafana_go2tech
  include role::nginx::missionrhode_go2tech

  include role::puppetboard

  include role::ganglia

  include role::profilinghost
  include role::xhgui

  include role::logstash
  include role::kibana
}

node 'donut.dwnet' {
  include droidwiki::default
  include monit
  include role::mariadb
  include role::parsoid
  include role::webserver
  include role::mediawiki
  include role::jobrunner
  include role::ganglia
  include certbot

  include role::nginx::droidwiki
  include role::nginx::data_droidwiki
  include role::nginx::donut_go2tech
}
