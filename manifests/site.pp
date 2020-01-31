# site.pp
node 'eclair.dwnet' {
  include droidwiki::default
  include role::mariadb
  include role::php
  class { 'role::mediawiki':
    isslave => true,
  }
  include role::mailserver
  include role::parsoid
  include role::deploymenthost
  class { 'certbot':
    mode => 'standalone',
    hook => 'service postfix restart',
  }
  include role::dns
  class { 'role::docker':
    manager => true,
  }
  include role::concourse
  include role::memcached
  include role::backup_s3_sync
}

node 'donut.dwnet' {
  include droidwiki::default
  include redis
  include role::mariadb
  include role::webserver
  include role::php
  include role::mediawiki
  include role::jobrunner
  include role::memcached
  include certbot
  include role::nfs_server
  class { 'role::docker':
    worker_ip => $facts['networking']['interfaces']['eth1']['ip'],
    token     => lookup( 'docker::worker_token' )
  }

  class { 'role::dns':
    type => 'master',
  }
  include role::nginx::droidwiki
  include role::nginx::ops_go2tech
  include role::datawiki
  include role::nginx::donut_go2tech
  include role::nginx::missionrhode_go2tech
  include role::nginx::blog_go2tech
  include role::nginx::ganglia_go2tech
  include role::nginx::go2tech
  include role::nginx::ci_go2tech
}
