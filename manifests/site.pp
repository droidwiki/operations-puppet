# site.pp
node 'eclair.dwnet' {
  include droidwiki::default
  include role::mariadb
  include role::php
  class { 'role::mediawiki':
    isslave => true,
  }
  include role::mailserver
  include role::puppetmaster
  include role::deploymenthost
  class { 'certbot':
    mode => 'standalone',
    hook => 'service postfix restart',
  }
  include role::dns
  include role::concourse

  include role::puppetboard

  include role::ganglia
  include role::memcached

  include role::nodejs
  include zotero
  include citoid

  # ganglia legacy options
  file { '/data/www/ganglia.go2tech.de':
    ensure => 'directory',
    force  => true,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  file { '/data/www/ganglia.go2tech.de/public_html':
    ensure => 'directory',
    force  => true,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }
}

node 'donut.dwnet' {
  include droidwiki::default
  include redis
  include role::mariadb
  include role::parsoid
  include role::webserver
  include role::php
  include role::mediawiki
  include role::jobrunner
  include role::ganglia
  include role::memcached
  include certbot
  include role::nfs_server
  include role::nodejs
  include restbase
  include mobileapps

  class { 'role::dns':
    type => 'master',
  }
  include role::nginx::droidwiki
  include role::nginx::data_droidwiki
  include role::nginx::ops_go2tech
  include role::datawiki
  include role::nginx::donut_go2tech
  include role::nginx::missionrhode_go2tech
  include role::nginx::puppetboard_go2tech
  include role::nginx::blog_go2tech
  include role::nginx::ganglia_go2tech
  include role::nginx::go2tech
  include role::nginx::ci_go2tech

  role::nginx::wiki{ 'endroidwikiwiki':
    domain      => 'en.droidwiki.org',
    server_name => [ 'en.droidwiki.org' ]
  }
}
